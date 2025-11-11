<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief MainResourceRepository class
 * @author dev@maarch.org
 */

declare(strict_types=1);

namespace MaarchCourrier\MainResource\Infrastructure\Repository;

use Convert\models\AdrModel;
use DateTimeImmutable;
use Exception;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceRepositoryInterface;
use MaarchCourrier\Core\Domain\User\Port\UserRepositoryInterface;
use MaarchCourrier\DocumentStorage\Domain\Document;
use MaarchCourrier\MainResource\Domain\Integration;
use MaarchCourrier\MainResource\Domain\MainResource;
use Resource\models\ResModel;
use SrcCore\models\DatabaseModel;

class MainResourceRepository implements MainResourceRepositoryInterface
{
    /**
     * @param UserRepositoryInterface $userRepository
     */
    public function __construct(
        private readonly UserRepositoryInterface $userRepository
    ) {
    }

    public function doesExistOnView(MainResourceInterface $mainResource, string $basketClause): bool
    {
        try {
            $res = DatabaseModel::select([
                'select'    => [1],
                'table'     => ['res_view_letterbox'],
                'where'     => ['res_id = ?', "($basketClause)"],
                'data'      => [$mainResource->getResId()]
            ]);
        } catch (Exception $e) {
            return false;
        }

        if (empty($res)) {
            return false;
        }

        return true;
    }

    /**
     * @param int $resId
     *
     * @return ?MainResourceInterface
     * @throws Exception
     */
    public function getMainResourceByResId(int $resId): ?MainResourceInterface
    {
        $resource = ResModel::getById(['resId' => $resId, 'select' => ['*']]);

        if (empty($resource)) {
            return null;
        }

        $typist = $this->userRepository->getUserById((int)$resource['typist']);

        $document = (new Document())
            ->setFileName($resource['filename'] ?? '')
            ->setFileExtension($resource['format'] ?? '');
        $integration = (new Integration())->createFromArray(json_decode($resource['integrations'], true));
        $checkExternalDocumentId = json_decode($resource['external_id'], true);
        $externalDocumentId = null;

        if (!empty($checkExternalDocumentId)) {
            $externalDocumentId = isset($checkExternalDocumentId['internalParapheur']) ?
                (int)$checkExternalDocumentId['internalParapheur'] : null;
        }

        return (new MainResource())
            ->setResId($resId)
            ->setSubject($resource['subject'])
            ->setChrono($resource['alt_identifier'])
            ->setTypist($typist)
            ->setDocument($document)
            ->setIntegration($integration)
            ->setExternalDocumentId($externalDocumentId)
            ->setExternalState(json_decode($resource['external_state'], true))
            ->setIntegration($integration)
            ->setVersion($resource['version'])
            ->setCreationDate(new DateTimeImmutable($resource['creation_date']))
            ->setModificationDate(new DateTimeImmutable($resource['modification_date']));
    }

    public function isMainResourceSigned(MainResourceInterface $mainResource): bool
    {
        $signedDocument = AdrModel::getDocuments([
            'select' => ['id'],
            'where'  => ['res_id = ?', 'type = ?'],
            'data'   => [$mainResource->getResId(), 'SIGN'],
            'limit'  => 1
        ]);

        return (!empty($signedDocument));
    }

    public function removeSignatureBookLink(MainResourceInterface $mainResource): void
    {
        ResModel::update([
            'postSet' => ['external_id' => "external_id - 'internalParapheur'"],
            'where'   => ['res_id = ?'],
            'data'    => [$mainResource->getResId()]
        ]);
    }
}
