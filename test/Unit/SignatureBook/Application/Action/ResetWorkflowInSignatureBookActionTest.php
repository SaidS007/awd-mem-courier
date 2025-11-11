<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Reset Workflow In Signature Book Test
 * @author dev@maarch.org
 */

namespace Unit\SignatureBook\Application\Action;

use DateTimeImmutable;
use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\Attachment\Domain\AttachmentType;
use MaarchCourrier\Core\Domain\MainResource\Problem\ResourceDoesNotExistProblem;
use MaarchCourrier\DocumentStorage\Domain\Document;
use MaarchCourrier\MainResource\Domain\Integration;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Application\Action\ResetWorkflowInSignatureBookAction;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\Workflow\NoWorkflowDefinedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\Workflow\WorkflowHasEndedProblem;
use MaarchCourrier\Tests\Unit\Attachment\Mock\AttachmentRepositoryMock;
use MaarchCourrier\Tests\Unit\Core\Mock\EnvironmentMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Config\SignatureServiceConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Repository\VisaWorkflowRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Link\SignatureBookLinkServiceMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Workflow\SignatureBookWorkflowServiceMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class ResetWorkflowInSignatureBookActionTest extends TestCase
{
    private EnvironmentMock $environmentMock;
    private SignatureServiceConfigLoaderMock $signatureServiceConfigLoaderMock;
    private SignatureBookWorkflowServiceMock $signatureBookWorkflowServiceMock;
    private VisaWorkflowRepositoryMock $visaWorkflowRepositoryMock;
    private MainResourceRepositoryMock $mainResourceRepositoryMock;
    private AttachmentRepositoryMock $attachmentRepositoryMock;
    private SignatureBookLinkServiceMock $signatureBookLinkServiceMock;
    private ResetWorkflowInSignatureBookAction $resetWorkflowInSignatureBook;

    protected function setUp(): void
    {
        $this->environmentMock = new EnvironmentMock();
        $this->signatureServiceConfigLoaderMock = new SignatureServiceConfigLoaderMock();
        $this->signatureBookWorkflowServiceMock = new SignatureBookWorkflowServiceMock();
        $this->visaWorkflowRepositoryMock = new VisaWorkflowRepositoryMock();
        $this->mainResourceRepositoryMock = new MainResourceRepositoryMock();
        $this->attachmentRepositoryMock = new AttachmentRepositoryMock();
        $this->signatureBookLinkServiceMock = new SignatureBookLinkServiceMock(
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
        $this->mainResourceRepositoryMock->mainResource = (new MainResource())
            ->setResId(42)
            ->setSubject('Courrier Test')
            ->setTypist($user)
            ->setChrono('MAARCH/2024/1')
            ->setDocument($document)
            ->setIntegration($integration)
            ->setCreationDate(new DateTimeImmutable())
            ->setModificationDate(new DateTimeImmutable())
            ->setExternalDocumentId(101);

        $this->attachmentRepositoryMock->attachmentsInSignatureBookWithAnInternalParapheur = [
            (new Attachment())
                ->setResId(1)
                ->setTitle('Demande de document')
                ->setChrono('MAARCH/2024/1')
                ->setMainResource($this->mainResourceRepositoryMock->mainResource)
                ->setTypist($user)
                ->setRelation(1)
                ->setType((new AttachmentType())
                    ->setType('response_project')
                    ->setLabel('Projet de réponse')
                    ->setSignable(true))
                ->setDocument($document)
                ->setCreationDate(new DateTimeImmutable())
                ->setModificationDate(new DateTimeImmutable())
            ->setExternalDocumentId(111)
        ];

        $this->resetWorkflowInSignatureBook = new ResetWorkflowInSignatureBookAction(
            $this->environmentMock,
            $this->signatureServiceConfigLoaderMock,
            $this->signatureBookWorkflowServiceMock,
            $this->visaWorkflowRepositoryMock,
            $this->mainResourceRepositoryMock,
            $this->attachmentRepositoryMock,
            $this->signatureBookLinkServiceMock
        );
    }

    /**
     * @return void
     * @throws NoWorkflowDefinedProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws WorkflowHasEndedProblem
     */
    public function testCannotGetMainResourceWhenResourceDoesNotExist(): void
    {
        $this->mainResourceRepositoryMock->mainResource = null;
        $this->expectExceptionObject(new ResourceDoesNotExistProblem());
        $this->resetWorkflowInSignatureBook->reset(100);
    }

    /**
     * @return void
     * @throws NoWorkflowDefinedProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws WorkflowHasEndedProblem
     */
    public function testCannotResetVisaWorkflowWhenWorkflowHasEnded(): void
    {
        $this->visaWorkflowRepositoryMock->isInWorkflow = false;
        $this->expectExceptionObject(new WorkflowHasEndedProblem());
        $this->resetWorkflowInSignatureBook->reset(100);
    }

    /**
     * @return void
     * @throws NoWorkflowDefinedProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws WorkflowHasEndedProblem
     */
    public function testCannotResetVisaWorkflowWhenWorkflowIsNotDefined(): void
    {
        $this->visaWorkflowRepositoryMock->isInWorkflow = false;
        $this->visaWorkflowRepositoryMock->hasWorkflow = false;
        $this->expectExceptionObject(new NoWorkflowDefinedProblem());
        $this->resetWorkflowInSignatureBook->reset(100);
    }

    /**
     * @return void
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws NoWorkflowDefinedProblem
     * @throws WorkflowHasEndedProblem
     */
    public function testCannotGetSignatureServiceConfigExpectProblem(): void
    {
        $this->environmentMock->isNewInternalParapheurEnabled = true;
        $this->signatureServiceConfigLoaderMock->isFileLoaded = false;
        $this->expectException(SignatureBookNoConfigFoundProblem::class);
        $this->resetWorkflowInSignatureBook->reset(100);
    }

    /**
     * @return void
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws NoWorkflowDefinedProblem
     * @throws WorkflowHasEndedProblem
     */
    public function testGetSignatureServiceJsonConfig(): void
    {
        $this->environmentMock->isNewInternalParapheurEnabled = true;
        $this->resetWorkflowInSignatureBook->reset(100);
        $this->assertNotEmpty($this->signatureBookWorkflowServiceMock->config);
    }

    public function testCanResetWorkflow(): void
    {
        $this->environmentMock->isNewInternalParapheurEnabled = true;
        $this->resetWorkflowInSignatureBook->reset(100);
        $this->assertTrue($this->visaWorkflowRepositoryMock->hasWorkflowResetForMainResource);
    }
}
