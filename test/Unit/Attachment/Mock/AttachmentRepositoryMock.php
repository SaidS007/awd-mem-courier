<?php

declare(strict_types=1);

namespace MaarchCourrier\Tests\Unit\Attachment\Mock;

use MaarchCourrier\Core\Domain\Attachment\Port\AttachmentInterface;
use MaarchCourrier\Core\Domain\Attachment\Port\AttachmentRepositoryInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceInterface;

class AttachmentRepositoryMock implements AttachmentRepositoryInterface
{
    /**
     * @var AttachmentInterface[]
     */
    public array $attachmentsInSignatureBook = [];
    /**
     * @var AttachmentInterface[]
     */
    public array $attachmentsInSignatureBookWithAnInternalParapheur = [];
    public AttachmentInterface $attachment;
    public bool $resourceUpdated = false;
    public bool $isAttachmentSigned = false;
    public bool $resIdConcordingWithResIdMaster = true;
    public bool $attachmentNotExists = false;
    public bool $isSignatureBookLinkRemoved = false;

    /**
     * @return AttachmentInterface[]
     */
    public function getAttachmentsInSignatureBookByMainResource(MainResourceInterface $mainResource): array
    {
        return $this->attachmentsInSignatureBook;
    }

    public function getAttachmentsWithAnInternalParapheur(MainResourceInterface $mainResource): array
    {
        return $this->attachmentsInSignatureBookWithAnInternalParapheur;
    }

    public function getAttachmentByResId(int $resId): ?AttachmentInterface
    {
        if ($this->attachmentNotExists) {
            return null;
        }
        return $this->attachment;
    }

    public function updateAttachment(AttachmentInterface $attachment, array $values): AttachmentInterface
    {
        $this->resourceUpdated = true;
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
                    $externalId = json_decode($value,true)['internalParapheur'];
                    $attachment->setExternalDocumentId($externalId);
                    break;
                case 'external_state':
                    $attachment->setExternalState(json_decode($value,true));
                    break;
                default :
                    break;
            }
        }
        return $attachment;
    }

    public function isSigned(AttachmentInterface $attachment): bool
    {
        return $this->isAttachmentSigned;
    }

    public function checkConcordanceResIdAndResIdMaster(
        AttachmentInterface $attachment,
        MainResourceInterface $mainResource
    ): bool {
        return $this->resIdConcordingWithResIdMaster;
    }

    public function removeSignatureBookLink(AttachmentInterface $attachment): void
    {;
        $this->isSignatureBookLinkRemoved = true;
    }
}
