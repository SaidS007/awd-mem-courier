<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief StoreSignedResourceService class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Infrastructure;

use Docserver\controllers\DocserverController;
use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\SignatureBook\Domain\Port\StoreSignedResourceServiceInterface;
use MaarchCourrier\SignatureBook\Domain\SignedResource;
use Resource\controllers\StoreController;

class StoreSignedResourceService implements StoreSignedResourceServiceInterface
{
    public function storeResource(SignedResource $signedResource): array
    {
        return DocserverController::storeResourceOnDocServer([
            'collId'          => 'letterbox_coll',
            'docserverTypeId' => 'DOC',
            'encodedResource' => $signedResource->getEncodedContent(),
            'format'          => 'pdf'
        ]);
    }

    public function storeAttachement(
        SignedResource $signedResource,
        Attachment $attachment,
        bool $storeSignedVersion
    ): int|array {
        $type = $attachment->getType()->getType();
        if ($storeSignedVersion) {
            $type = 'signed_response';
        }

        $originId = $signedResource->getResIdSigned();
        if (!empty($attachment->getOriginId())) {
            $originId = $attachment->getOriginId();
        }

        $data = [
            'title'                    => $attachment->getTitle(),
            'encodedFile'              => $signedResource->getEncodedContent(),
            'status'                   => ($storeSignedVersion) ? 'TRA' : 'FRZ',
            'format'                   => 'pdf',
            'typist'                   => $attachment->getTypist()->getId(),
            'resIdMaster'              => $attachment->getMainResource()->getResId(),
            'chrono'                   => $attachment->getChrono(),
            'type'                     => $type,
            'originId'                 => $originId,
            'recipientId'              => $attachment->getRecipientId(),
            'recipientType'            => $attachment->getRecipientType(),
            'inSignatureBook'          => true,
            'signatory_user_serial_id' => $signedResource->getUserSerialId()
        ];

        $id = StoreController::storeAttachment($data);
        if (!empty($id['errors'])) {
            return ['errors' => $id['errors']];
        }

        return $id;
    }
}
