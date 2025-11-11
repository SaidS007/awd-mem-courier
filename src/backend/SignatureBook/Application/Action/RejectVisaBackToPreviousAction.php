<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief RejectVisaBackToPrevious Action
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Application\Action;

use MaarchCourrier\Core\Domain\Attachment\Port\AttachmentRepositoryInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceRepositoryInterface;
use MaarchCourrier\Core\Domain\User\Port\CurrentUserInterface;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\MainResource\Domain\Problem\MainResourceDoesNotExistProblem;
use MaarchCourrier\SignatureBook\Domain\Port\SignatureServiceConfigLoaderInterface;
use MaarchCourrier\SignatureBook\Domain\Port\SignatureServiceInterface;
use MaarchCourrier\SignatureBook\Domain\Problem\CurrentTokenIsNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\SignatureBookServiceConfig;

class RejectVisaBackToPreviousAction
{
    public ?MainResource $mainResource = null;
    public ?array $attachments = [];
    public ?SignatureBookServiceConfig $signatureBook = null;
    public ?string $accessToken = null;

    public function __construct(
        private readonly CurrentUserInterface $currentUser,
        private readonly MainResourceRepositoryInterface $mainResourceRepository,
        private readonly AttachmentRepositoryInterface $attachmentRepository,
        private readonly SignatureServiceInterface $parapheurSignatureService,
        private readonly SignatureServiceConfigLoaderInterface $signatureServiceConfigLoader,
        private readonly bool $isNewSignatureBookEnabled
    ) {
    }

    public function execute(int $resId): bool
    {
        if (!$this->isNewSignatureBookEnabled) {
            return true;
        }

        $this->signatureBook = $this->signatureServiceConfigLoader->getSignatureServiceConfig();
        if ($this->signatureBook === null) {
            throw new SignatureBookNoConfigFoundProblem();
        }
        $this->accessToken = $this->currentUser->getCurrentUserToken();
        if (empty($this->accessToken)) {
            throw new CurrentTokenIsNotFoundProblem();
        }

        $this->mainResource = $this->mainResourceRepository->getMainResourceByResId($resId);
        if (!$this->mainResource) {
            throw new MainResourceDoesNotExistProblem();
        }

        $this->attachments =
            $this->attachmentRepository->getAttachmentsInSignatureBookByMainResource($this->mainResource);

        $this->revertInParapheur();

        return true;
    }

    public function revertInParapheur(): bool
    {
        if (!empty($this->mainResource->getExternalDocumentId())) {
            $this->parapheurSignatureService->setConfig($this->signatureBook)->revertLastStep(
                $this->accessToken,
                $this->mainResource->getExternalDocumentId()
            );
        }

        foreach ($this->attachments as $attachment) {
            if (!empty($attachment->getExternalDocumentId())) {
                $this->parapheurSignatureService->setConfig($this->signatureBook)->revertLastStep(
                    $this->accessToken,
                    $attachment->getExternalDocumentId()
                );
            }
        }

        return true;
    }
}
