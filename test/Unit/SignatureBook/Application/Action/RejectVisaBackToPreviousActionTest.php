<?php

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application\Action;

use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\DocumentStorage\Domain\Document;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\MainResource\Domain\Problem\MainResourceDoesNotExistProblem;
use MaarchCourrier\SignatureBook\Application\Action\RejectVisaBackToPreviousAction;
use MaarchCourrier\SignatureBook\Domain\Problem\CurrentTokenIsNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\Tests\Unit\Attachment\Mock\AttachmentRepositoryMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\MaarchParapheurSignatureServiceMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\SignatureServiceJsonConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\CurrentUserInformationsMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class RejectVisaBackToPreviousActionTest extends TestCase
{
    private RejectVisaBackToPreviousAction $rejectVisaBackToPreviousAction;
    private MainResourceRepositoryMock $mainResourceRepositoryMock;
    private AttachmentRepositoryMock $attachmentRepositoryMock;
    private CurrentUserInformationsMock $currentUserRepositoryMock;
    private SignatureServiceJsonConfigLoaderMock $configLoaderMock;
    private MaarchParapheurSignatureServiceMock $signatureServiceMock;

    protected function setUp(): void
    {
        $this->mainResourceRepositoryMock = new MainResourceRepositoryMock();
        $this->attachmentRepositoryMock = new AttachmentRepositoryMock();
        $this->currentUserRepositoryMock = new CurrentUserInformationsMock();
        $this->configLoaderMock = new SignatureServiceJsonConfigLoaderMock();
        $this->signatureServiceMock = new MaarchParapheurSignatureServiceMock();

        $this->rejectVisaBackToPreviousAction = new RejectVisaBackToPreviousAction(
            $this->currentUserRepositoryMock,
            $this->mainResourceRepositoryMock,
            $this->attachmentRepositoryMock,
            $this->signatureServiceMock,
            $this->configLoaderMock,
            true
        );

        $user = new User();
        $user->setId(1);

        $document = (new Document())
            ->setFileName('the-file.pdf')
            ->setFileExtension('pdf');

        $this->mainResourceRepositoryMock->mainResource = (new MainResource())
            ->setResId(100)
            ->setTypist($user)
            ->setDocument($document)
            ->setExternalDocumentId(10)
        ;

        $this->attachmentRepositoryMock->attachment = (new Attachment())
            ->setResId(1)
            ->setMainResource($this->mainResourceRepositoryMock->mainResource)
            ->setStatus('FRZ')
            ->setDocument($document)
            ->setExternalDocumentId(20);

        $this->signatureServiceMock->revertVisaStep = false;
    }

    /**
     * @return void
     * @throws MainResourceDoesNotExistProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     */
    public function testNewParapheurIsEnabled(): void
    {
        $result = $this->rejectVisaBackToPreviousAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId()
        );
        $this->assertTrue($result);
    }

    /**
     * @return void
     * @throws CurrentTokenIsNotFoundProblem
     * @throws MainResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     */
    public function testCannotRevertVisaWorkflowIfTheSignatureBookConfigIsNotFound(): void
    {
        $this->configLoaderMock->signatureServiceConfigLoader = null;
        $this->expectException(SignatureBookNoConfigFoundProblem::class);
        $this->rejectVisaBackToPreviousAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId()
        );
    }

    /**
     * @return void
     * @throws CurrentTokenIsNotFoundProblem
     * @throws MainResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     */
    public function testCanRevertVisaWorkflowInParapheurIfExternalIdSetForMainResourceOnly(): void
    {
        $this->attachmentRepositoryMock->attachmentsInSignatureBook = [];

        $this->rejectVisaBackToPreviousAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId()
        );
        $this->assertTrue($this->signatureServiceMock->revertVisaStep);
    }

    public function testCanRevertVisaWorkInParapheurIfExternalIdSetForAttachmentOnly(): void
    {
        $this->mainResourceRepositoryMock->mainResource->setExternalDocumentId(null);
        $this->attachmentRepositoryMock->attachmentsInSignatureBook[] = $this->attachmentRepositoryMock->attachment;

        $this->rejectVisaBackToPreviousAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId()
        );
        $this->assertTrue($this->signatureServiceMock->revertVisaStep);
    }

    /**
     * @return void
     * @throws CurrentTokenIsNotFoundProblem
     * @throws MainResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     */
    public function testCanExecuteActionIfAttachmentsListIsEmpty(): void
    {
        $this->attachmentRepositoryMock->attachmentsInSignatureBook = [];

        $result = $this->rejectVisaBackToPreviousAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId()
        );
        $this->assertTrue($result);
    }

    /**
     * @return void
     * @throws CurrentTokenIsNotFoundProblem
     * @throws MainResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     */
    public function testCannotExecuteActionIfMainResourceDoesNotExist(): void
    {
        $resId = $this->mainResourceRepositoryMock->mainResource->getResId();
        $this->mainResourceRepositoryMock->mainResource = null;

        $this->expectException(MainResourceDoesNotExistProblem::class);
        $result = $this->rejectVisaBackToPreviousAction->execute(
            $resId
        );
    }
}
