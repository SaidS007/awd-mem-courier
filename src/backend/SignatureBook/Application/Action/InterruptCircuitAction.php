<?php

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

class InterruptCircuitAction
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

    public function execute(int $resId, array $note): bool
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


        $this->refuseInParapheur($note['content'] ?? null);
        $this->unfreezeAttachments();

        return true;
    }

    public function unfreezeAttachments(): void
    {
        foreach ($this->attachments as $attachment) {
            $this->attachmentRepository->updateAttachment(
                $attachment,
                ['status' => 'A_TRA']
            );
        }
    }

    public function refuseInParapheur(?string $note = null): bool
    {
        if (!empty($this->mainResource->getExternalDocumentId())) {
            $this->parapheurSignatureService->setConfig($this->signatureBook)->refuseSignature(
                $this->accessToken,
                $this->mainResource->getExternalDocumentId(),
                $note
            );
        }


        foreach ($this->attachments as $attachment) {
            if (!empty($attachment->getExternalDocumentId())) {
                $this->parapheurSignatureService->setConfig($this->signatureBook)->refuseSignature(
                    $this->accessToken,
                    $attachment->getExternalDocumentId(),
                    $note
                );
            }
        }

        return true;
    }
}
