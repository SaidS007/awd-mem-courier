<?php

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application\Action;

use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\DocumentStorage\Domain\Document;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\MainResource\Domain\Problem\MainResourceDoesNotExistProblem;
use MaarchCourrier\SignatureBook\Application\Action\InterruptCircuitAction;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\Tests\Unit\Attachment\Mock\AttachmentRepositoryMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\MaarchParapheurSignatureServiceMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\SignatureServiceJsonConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\CurrentUserInformationsMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class InterruptCircuitActionTest extends TestCase
{
    private InterruptCircuitAction $interruptCircuitAction;
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

        $this->interruptCircuitAction = new InterruptCircuitAction(
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


        $this->signatureServiceMock->refuseSignature = false;
    }

    public function testNewParapheurIsEnabled(): void
    {
        $result = $this->interruptCircuitAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId(),
            []
        );
        $this->assertTrue($result);
    }

    public function testCannotRefuseIfTheSignatureBookConfigIsNotFound(): void
    {
        $this->configLoaderMock->signatureServiceConfigLoader = null;
        $this->expectException(SignatureBookNoConfigFoundProblem::class);
        $this->interruptCircuitAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId(),
            []
        );
    }

    public function testCanRefuseInParapheurIfExternalIdSetForMainResourceOnly(): void
    {
        $this->attachmentRepositoryMock->attachmentsInSignatureBook = [];

        $this->interruptCircuitAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId(),
            []
        );
        $this->assertTrue($this->signatureServiceMock->refuseSignature);
    }

    public function testCanRefuseInParapheurIfExternalIdSetForAttachmentOnly(): void
    {
        $this->mainResourceRepositoryMock->mainResource->setExternalDocumentId(null);
        $this->attachmentRepositoryMock->attachmentsInSignatureBook[] = $this->attachmentRepositoryMock->attachment;

        $this->interruptCircuitAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId(),
            []
        );
        $this->assertTrue($this->signatureServiceMock->refuseSignature);
    }

    public function testCanUnfreezeAttachment(): void
    {
        $this->attachmentRepositoryMock->attachmentsInSignatureBook[] = $this->attachmentRepositoryMock->attachment;

        $result = $this->interruptCircuitAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId(),
            []
        );
        $this->assertSame('A_TRA', $this->attachmentRepositoryMock->attachment->getStatus());
    }

    public function testCanExecuteActionIfAttachmentsListIsEmpty(): void
    {
        $this->attachmentRepositoryMock->attachmentsInSignatureBook = [];

        $result = $this->interruptCircuitAction->execute(
            $this->mainResourceRepositoryMock->mainResource->getResId(),
            []
        );
        $this->assertTrue($result);
    }

    public function testCannotExecuteActionIfMainResourceDoesNotExist(): void
    {
        $resId = $this->mainResourceRepositoryMock->mainResource->getResId();
        $this->mainResourceRepositoryMock->mainResource = null;

        $this->expectException(MainResourceDoesNotExistProblem::class);
        $result = $this->interruptCircuitAction->execute(
            $resId,
            []
        );
    }
}
