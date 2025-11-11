<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Signature Book Link Service Test
 * @author dev@maarch.org
 */

namespace Unit\SignatureBook\Infrastructure\Service;

use DateTimeImmutable;
use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\Attachment\Domain\AttachmentType;
use MaarchCourrier\DocumentStorage\Domain\Document;
use MaarchCourrier\MainResource\Domain\Integration;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Domain\Problem\Link\DeleteResourceInSignatureBookProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\Link\InterruptWorkflowInSignatureBookProblem;
use MaarchCourrier\SignatureBook\Domain\SignatureBookResource;
use MaarchCourrier\SignatureBook\Infrastructure\Service\SignatureBookLinkService;
use MaarchCourrier\Tests\Unit\Attachment\Mock\AttachmentRepositoryMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Workflow\SignatureBookWorkflowServiceMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class SignatureBookLinkServiceTest extends TestCase
{
    private MainResource $mainResource;
    private Attachment $attachment;
    private SignatureBookResource $signatureBookResource;
    private SignatureBookWorkflowServiceMock $signatureBookWorkflowServiceMock;
    private MainResourceRepositoryMock $mainResourceRepositoryMock;
    private AttachmentRepositoryMock $attachmentRepositoryMock;
    private SignatureBookLinkService $signatureBookLinkService;

    protected function setUp(): void
    {
        $this->signatureBookWorkflowServiceMock = new SignatureBookWorkflowServiceMock();
        $this->mainResourceRepositoryMock = new MainResourceRepositoryMock();
        $this->attachmentRepositoryMock = new AttachmentRepositoryMock();
        $this->signatureBookLinkService = new SignatureBookLinkService(
            $this->signatureBookWorkflowServiceMock,
            $this->mainResourceRepositoryMock,
            $this->attachmentRepositoryMock
        );

        $user = new User();
        $user->setId(1);
        $document = (new Document())
            ->setFileName('the-file.pdf')
            ->setFileExtension('pdf');
        $integration = (new Integration())->setInSignatureBook(false);
        $this->mainResource = (new MainResource())
            ->setResId(42)
            ->setSubject('Courrier Test')
            ->setTypist($user)
            ->setChrono('MAARCH/2024/1')
            ->setDocument($document)
            ->setIntegration($integration)
            ->setCreationDate(new DateTimeImmutable())
            ->setModificationDate(new DateTimeImmutable())
            ->setExternalDocumentId(101);

        $this->attachment = (new Attachment())
            ->setResId(1)
            ->setTitle('Demande de document')
            ->setChrono('MAARCH/2024/1')
            ->setMainResource($this->mainResource)
            ->setTypist($user)
            ->setRelation(1)
            ->setType((new AttachmentType())
                ->setType('response_project')
                ->setLabel('Projet de réponse')
                ->setSignable(true))
            ->setDocument($document)
            ->setCreationDate(new DateTimeImmutable())
            ->setModificationDate(new DateTimeImmutable())
            ->setExternalDocumentId(111);

        $this->signatureBookResource = (new SignatureBookResource())
            ->setResource($this->mainResource);
    }

    /**
     * @return void
     * @throws InterruptWorkflowInSignatureBookProblem
     * @throws DeleteResourceInSignatureBookProblem
     */
    public function testCannotResetMainDocumentWorkflowWhenAnErrorOccurredDuringTheInterruptionOfWorkflowInSignatureBook(): void
    {
        $this->signatureBookResource->setResource($this->mainResource);
        $this->signatureBookWorkflowServiceMock->didWorkflowinterrupted = false;
        $this->expectException(InterruptWorkflowInSignatureBookProblem::class);
        $this->signatureBookLinkService->unlinkResources($this->signatureBookResource);
    }

    /**
     * @return void
     * @throws InterruptWorkflowInSignatureBookProblem
     * @throws DeleteResourceInSignatureBookProblem
     */
    public function testCannotResetAttachmentWorkflowWhenAnErrorOccurredDuringTheInterruptionOfWorkflowInSignatureBook(): void
    {
        $this->signatureBookResource->setResource($this->attachment);
        $this->signatureBookWorkflowServiceMock->didWorkflowinterrupted = false;
        $this->expectException(InterruptWorkflowInSignatureBookProblem::class);
        $this->signatureBookLinkService->unlinkResources($this->signatureBookResource);
    }

    /**
     * @return void
     * @throws DeleteResourceInSignatureBookProblem
     * @throws InterruptWorkflowInSignatureBookProblem
     */
    public function testCannotResetMainDocumentWorkflowWhenAnErrorOccurredDuringTheDeletionOfTheDocumentInSignatureBook(): void
    {
        $this->signatureBookResource->setResource($this->mainResource);
        $this->signatureBookWorkflowServiceMock->didResourceDeleted = false;
        $this->expectException(DeleteResourceInSignatureBookProblem::class);
        $this->signatureBookLinkService->unlinkResources($this->signatureBookResource);
    }

    /**
     * @return void
     * @throws DeleteResourceInSignatureBookProblem
     * @throws InterruptWorkflowInSignatureBookProblem
     */
    public function testCannotResetAttachmentWorkflowWhenAnErrorOccurredDuringTheDeletionOfTheDocumentInSignatureBook(): void
    {
        $this->signatureBookResource->setResource($this->attachment);
        $this->signatureBookWorkflowServiceMock->didResourceDeleted = false;
        $this->expectException(DeleteResourceInSignatureBookProblem::class);
        $this->signatureBookLinkService->unlinkResources($this->signatureBookResource);
    }

    /**
     * @return void
     * @throws DeleteResourceInSignatureBookProblem
     * @throws InterruptWorkflowInSignatureBookProblem
     */
    public function testCanRemoveSignatureBookLinkForMainResource(): void
    {
        $this->signatureBookResource->setResource($this->mainResource);
        $this->signatureBookLinkService->unlinkResources($this->signatureBookResource);
        $this->assertTrue($this->mainResourceRepositoryMock->isSignatureBookLinkRemoved);
    }

    /**
     * @return void
     * @throws DeleteResourceInSignatureBookProblem
     * @throws InterruptWorkflowInSignatureBookProblem
     */
    public function testCanRemoveSignatureBookLinkForSignableAttachment(): void
    {
        $this->signatureBookResource->setResource($this->attachment);
        $this->signatureBookLinkService->unlinkResources($this->signatureBookResource);
        $this->assertTrue($this->attachmentRepositoryMock->isSignatureBookLinkRemoved);
    }
}
