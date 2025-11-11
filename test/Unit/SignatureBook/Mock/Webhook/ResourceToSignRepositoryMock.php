<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief   ResourceToSignRepository mock
 * @author  dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Mock\Webhook;

use MaarchCourrier\SignatureBook\Domain\Port\ResourceToSignRepositoryInterface;

class ResourceToSignRepositoryMock implements ResourceToSignRepositoryInterface
{
    public bool $signedVersionCreate = false;
    public bool $resourceUpdated = false;
    public bool $resourceNotExists = false;
    public bool $attachmentNotExists = false;
    public bool $resourceAlreadySigned = false;
    public bool $newVersionResourceSet = false;
    public int $numNewVersionResource = 0;

    public array $resourceInformations = [
        'version'      => 1,
        'external_id'  => '{}',
        'format'       => 'docx',
        'docserver_id' => 'FASTHD_MAN',
        'path'         => '2024/06/001',
        'filename'     => 'toto.docx',
        'fingerprint'  => '123456azerty',
        'filesize'     => '123456',
    ];

    public array $attachmentInformations = [
        'res_id_master'   => 100,
        'title'           => 'PDF_Reponse_blocsignature',
        'typist'          => 19,
        'identifier'      => 'MAARCH/2024D/1000',
        'recipient_id'    => 6,
        'recipient_type'  => 'contact',
        'format'          => 'pdf',
        'status'          => 'TRA',
        'origin'          => null,
        'origin_id'       => null,
        'relation'        => 1,
        'attachment_type' => 'response_project',
        'external_id'     => '{"internalParapheur":20}',
        'external_state'  => '{"hasDigitalSignature":true,"hasStampSignature":true}'
    ];

    public function getResourceInformations(int $resId): array
    {
        if ($this->resourceNotExists) {
            return [];
        }
        return $this->resourceInformations;
    }

    public function getAttachmentInformations(int $resId): array
    {
        if ($this->attachmentNotExists) {
            return [];
        }

        return $this->attachmentInformations;
    }

    public function createSignVersionForResource(int $resId, array $storeInformations): void
    {
        $this->numNewVersionResource = 1;

        $this->signedVersionCreate = true;
    }

    public function isResourceSigned(int $resId): bool
    {
        return $this->resourceAlreadySigned;
    }

    public function isAttachementSigned(int $resId): bool
    {
        return $this->resourceAlreadySigned;
    }


    public function setResourceExternalId(int $resId, int $parapheurDocumentId): void
    {
        $this->resourceUpdated = true;
    }

    public function createIntermediateSignedVersionForResource(int $resId, array $storeInformations): void
    {
        $this->newVersionResourceSet = true;
        $this->numNewVersionResource = $this->resourceInformations['version'] + 1;
    }

    public function setResourceInformations(int $resId, array $setValues): void
    {
        foreach ($setValues as $key => $value) {
            $this->resourceInformations[$key] = $value;
        }
    }
}
