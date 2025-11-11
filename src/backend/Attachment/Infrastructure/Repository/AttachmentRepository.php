<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief AttachmentRepository class
 * @author dev@maarch.org
 */

declare(strict_types=1);

namespace MaarchCourrier\Attachment\Infrastructure\Repository;

use Attachment\models\AttachmentModel;
use Attachment\models\AttachmentTypeModel;
use DateTimeImmutable;
use Exception;
use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\Attachment\Domain\AttachmentType;
use MaarchCourrier\Core\Domain\Attachment\Port\AttachmentInterface;
use MaarchCourrier\Core\Domain\Attachment\Port\AttachmentRepositoryInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceRepositoryInterface;
use MaarchCourrier\Core\Domain\User\Port\UserRepositoryInterface;
use MaarchCourrier\DocumentStorage\Domain\Document;

class AttachmentRepository implements AttachmentRepositoryInterface
{
    /**
     * @param UserRepositoryInterface $userRepository
     * @param MainResourceRepositoryInterface $mainResourceRepository
     */
    public function __construct(
        private readonly UserRepositoryInterface $userRepository,
        private readonly MainResourceRepositoryInterface $mainResourceRepository
    ) {
    }

    /**
     * @param MainResourceInterface $mainResource
     * @return Attachment[]
     * @throws Exception
     */
    public function getAttachmentsInSignatureBookByMainResource(MainResourceInterface $mainResource): array
    {
        $where = [
            'res_id_master = ?',
            'in_signature_book = ?',
            "status not in ('DEL', 'TMP', 'OBS', 'SIGN')"
        ];
        $data = [$mainResource->getResId(), 'true'];

        return $this->fetchAndMapAttachments($mainResource, $where, $data);
    }

    /**
     * @param MainResourceInterface $mainResource
     *
     * @return Attachment[]
     * @throws Exception
     */
    public function getAttachmentsWithAnInternalParapheur(MainResourceInterface $mainResource): array
    {
        $where = [
            'res_id_master = ?', 'in_signature_book = ?', "status not in ('DEL', 'TMP', 'OBS')",
            "external_id->>'internalParapheur' IS NOT NULL"
        ];
        $data = [$mainResource->getResId(), 'true'];

        return $this->fetchAndMapAttachments($mainResource, $where, $data);
    }

    /**
     * @param int $resId
     *
     * @return AttachmentInterface|null
     * @throws Exception
     */
    public function getAttachmentByResId(int $resId): ?AttachmentInterface
    {
        $attachmentTypes = $this->getAttachmentTypes();

        $data = AttachmentModel::getById([
            'id'     => $resId,
            'select' => ['*']
        ]);

        if (empty($data)) {
            return null;
        }

        return $this->mapAttachment($data, $attachmentTypes);
    }

    /**
     * @param AttachmentInterface $attachment
     * @param array $values
     *
     * @return AttachmentInterface
     * @throws Exception
     */
    public function updateAttachment(AttachmentInterface $attachment, array $values): AttachmentInterface
    {
        AttachmentModel::update([
            'set'   => $values,
            'where' => ['res_id = ?'],
            'data'  => [$attachment->getResId()]
        ]);

        $this->updateAttachmentProperties($attachment, $values);
        return $attachment;
    }

    /**
     * @param AttachmentInterface $attachment
     *
     * @return bool
     */
    public function isSigned(AttachmentInterface $attachment): bool
    {
        return ($attachment->getStatus() === 'SIGN');
    }

    /**
     * @param AttachmentInterface $attachment
     * @param MainResourceInterface $mainResource
     *
     * @return bool
     */
    public function checkConcordanceResIdAndResIdMaster(
        AttachmentInterface $attachment,
        MainResourceInterface $mainResource
    ): bool {
        return ($attachment->getMainResource()->getResId() === $mainResource->getResId());
    }

    /**
     * @param AttachmentInterface $attachment
     *
     * @return void
     * @throws Exception
     */
    public function removeSignatureBookLink(AttachmentInterface $attachment): void
    {
        AttachmentModel::update([
            'postSet' => ['external_id' => "external_id - 'internalParapheur'"],
            'where'   => ['res_id = ?'],
            'data'    => [$attachment->getResId()]
        ]);
    }

    /**
     * @return array
     * @throws Exception
     */
    private function getAttachmentTypes(): array
    {
        $attachmentTypes = AttachmentTypeModel::get(['select' => ['type_id', 'label', 'signable']]);
        $attachmentTypes = array_column($attachmentTypes, null, 'type_id');

        foreach ($attachmentTypes as $type => $attachmentType) {
            $attachmentTypes[$type] = (new AttachmentType())
                ->setType($type)
                ->setLabel($attachmentType['label'])
                ->setSignable($attachmentType['signable']);
        }

        return $attachmentTypes;
    }

    /**
     * @param MainResourceInterface $mainResource
     * @param array $where
     * @param array $data
     *
     * @return array
     * @throws Exception
     */
    private function fetchAndMapAttachments(MainResourceInterface $mainResource, array $where, array $data): array
    {
        $attachmentTypes = $this->getAttachmentTypes();

        $attachmentsData = AttachmentModel::get([
            'select' => ['*'],
            'where'  => $where,
            'data'   => $data
        ]);

        return $this->mapAttachments($attachmentsData, $attachmentTypes, $mainResource);
    }

    /**
     * @param array $attachmentsData
     * @param array $attachmentTypes
     * @param MainResourceInterface $mainResource
     *
     * @return array
     * @throws Exception
     */
    private function mapAttachments(
        array $attachmentsData,
        array $attachmentTypes,
        MainResourceInterface $mainResource
    ): array {
        $attachments = [];
        foreach ($attachmentsData as $data) {
            $attachments[] = $this->mapAttachment($data, $attachmentTypes, $mainResource);
        }
        return $attachments;
    }

    /**
     * @param array $data
     * @param array $attachmentTypes
     * @param MainResourceInterface|null $mainResource If null then we fetch main resource
     *
     * @return Attachment
     * @throws Exception
     */
    private function mapAttachment(
        array $data,
        array $attachmentTypes,
        MainResourceInterface $mainResource = null
    ): Attachment {
        $typist = $this->userRepository->getUserById((int)$data['typist']);
        if (empty($mainResource)) {
            $mainResource = $this->mainResourceRepository->getMainResourceByResId($data['res_id_master']);
        }

        $document = (new Document())
            ->setFileName($data['filename'])
            ->setFileExtension($data['format']);

        $checkExternalDocumentId = json_decode($data['external_id'], true);
        $externalDocumentId = null;

        if (!empty($checkExternalDocumentId)) {
            $externalDocumentId = (int)($checkExternalDocumentId['internalParapheur']) ?? null;
        }

        return (new Attachment())
            ->setResId($data['res_id'])
            ->setMainResource($mainResource)
            ->setTitle($data['title'])
            ->setChrono($data['identifier'] ?? '')
            ->setTypist($typist)
            ->setRelation($data['relation'])
            ->setType($attachmentTypes[$data['attachment_type']])
            ->setDocument($document)
            ->setExternalDocumentId($externalDocumentId)
            ->setExternalState(json_decode($data['external_state'], true))
            ->setRecipientId($data['recipient_id'])
            ->setRecipientType($data['recipient_type'])
            ->setStatus($data['status'])
            ->setOriginId($data['origin_id'])
            ->setVersion($data['relation'])
            ->setCreationDate(new DateTimeImmutable($data['creation_date']))
            ->setModificationDate(new DateTimeImmutable($data['modification_date']));
    }

    /**
     * @param string|null $externalId
     *
     * @return int|null
     */
    private function getInternalParapheurFromExternalId(?string $externalId): ?int
    {
        $decoded = json_decode($externalId, true);
        return !empty($decoded['internalParapheur']) ? (int)$decoded['internalParapheur'] : null;
    }

    /**
     * @param AttachmentInterface $attachment
     * @param array $values
     *
     * @return void
     */
    private function updateAttachmentProperties(AttachmentInterface $attachment, array $values): void
    {
        foreach ($values as $key => $value) {
            switch ($key) {
                case 'title':
                    $attachment->setTitle($value);
                    break;
                case 'status':
                    $attachment->setStatus($value);
                    break;
                case 'relation':
                    $attachment->setRelation($value);
                    break;
                case 'external_id':
                    $attachment->setExternalDocumentId($this->getInternalParapheurFromExternalId($value));
                    break;
                case 'external_state':
                    $attachment->setExternalState(json_decode($value, true));
                    break;
                default:
                    break;
            }
        }
    }
}
