<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Signature Book Link Service Mock
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Mock\Link;

use MaarchCourrier\Core\Domain\Attachment\Port\AttachmentRepositoryInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceRepositoryInterface;
use MaarchCourrier\SignatureBook\Domain\Port\Link\SignatureBookLinkServiceInterface;
use MaarchCourrier\SignatureBook\Domain\Port\Workflow\SignatureBookWorkflowServiceInterface;
use MaarchCourrier\SignatureBook\Domain\SignatureBookResource;

class SignatureBookLinkServiceMock implements SignatureBookLinkServiceInterface
{
    public array|bool $interruptWorkflowReturns;
    public array|bool $deleteResourceReturns;

    /**
     * @param SignatureBookWorkflowServiceInterface $signatureBookWorkflowService
     * @param MainResourceRepositoryInterface $mainResourceRepository
     * @param AttachmentRepositoryInterface $attachmentRepository
     */
    public function __construct(
        private readonly SignatureBookWorkflowServiceInterface $signatureBookWorkflowService,
        private readonly MainResourceRepositoryInterface $mainResourceRepository,
        private readonly AttachmentRepositoryInterface $attachmentRepository
    ) {
    }

    public function unlinkResources(SignatureBookResource $signatureBookResource): void
    {
        $this->interruptWorkflowReturns = $this->signatureBookWorkflowService->interruptWorkflow(
            $signatureBookResource
        );
        $this->deleteResourceReturns = $this->signatureBookWorkflowService->deleteResource($signatureBookResource);

        if ($signatureBookResource->getResource() instanceof MainResourceInterface) {
            $this->mainResourceRepository->removeSignatureBookLink($signatureBookResource->getResource());
        } else {
            $this->attachmentRepository->removeSignatureBookLink($signatureBookResource->getResource());
            $this->attachmentRepository->updateAttachment($signatureBookResource->getResource(), ['status' => 'A_TRA']);
        }
    }
}
