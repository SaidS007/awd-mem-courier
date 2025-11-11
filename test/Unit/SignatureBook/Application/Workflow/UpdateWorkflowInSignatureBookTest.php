<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Update Workflow In Signature Book Test
 * @author dev@maarch.org
 */

namespace Unit\SignatureBook\Application\Workflow;

use DateTimeImmutable;
use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\Attachment\Domain\AttachmentType;
use MaarchCourrier\Core\Domain\MainResource\Problem\ResourceDoesNotExistProblem;
use MaarchCourrier\Core\Domain\User\Problem\UserDoesNotExistProblem;
use MaarchCourrier\Core\Domain\User\Problem\UserIsNotSyncInSignatureBookProblem;
use MaarchCourrier\DocumentStorage\Domain\Document;
use MaarchCourrier\MainResource\Domain\Integration;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Application\Workflow\UpdateWorkflowInSignatureBook;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\Workflow\CheckWorkflowExistenceInSignatureBookProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\Workflow\CouldNotUpdateWorkflowInSignatureBookProblem;
use MaarchCourrier\SignatureBook\Domain\SignatureMode;
use MaarchCourrier\Tests\Unit\Attachment\Mock\AttachmentRepositoryMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Config\SignatureServiceConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\UserRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Workflow\SignatureBookWorkflowServiceMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class UpdateWorkflowInSignatureBookTest extends TestCase
{
    private Attachment $attachmentMock;
    private SignatureServiceConfigLoaderMock $signatureServiceConfigLoaderMock;
    private SignatureBookWorkflowServiceMock $signatureBookWorkflowServiceMock;
    private UserRepositoryMock $userRepositoryMock;
    private MainResourceRepositoryMock $mainResourceRepositoryMock;
    private AttachmentRepositoryMock $attachmentRepositoryMock;
    private UpdateWorkflowInSignatureBook $updateWorkflowInSignatureBook;

    protected function setUp(): void
    {
        $this->signatureServiceConfigLoaderMock = new SignatureServiceConfigLoaderMock();
        $this->signatureBookWorkflowServiceMock = new SignatureBookWorkflowServiceMock();
        $this->userRepositoryMock = new UserRepositoryMock();
        $this->mainResourceRepositoryMock = new MainResourceRepositoryMock();
        $this->attachmentRepositoryMock = new AttachmentRepositoryMock();

        $this->userRepositoryMock->doesInternalParapheurExist = true;

        $this->user = (new User())
            ->setId(1);
        $document = (new Document())
            ->setFileName('the-file.pdf')
            ->setFileExtension('pdf');
        $integration = (new Integration())->setInSignatureBook(false);
        $this->mainResourceRepositoryMock->mainResource = (new MainResource())
            ->setResId(100)
            ->setSubject('Courrier Test')
            ->setTypist($this->user)
            ->setChrono('MAARCH/2024/100')
            ->setDocument($document)
            ->setIntegration($integration)
            ->setCreationDate(new DateTimeImmutable())
            ->setModificationDate(new DateTimeImmutable());

        $this->attachmentMock = (new Attachment())
            ->setResId(1)
            ->setTitle('Demande de document')
            ->setChrono('MAARCH/2024/1')
            ->setMainResource($this->mainResourceRepositoryMock->mainResource)
            ->setTypist($this->user)
            ->setRelation(1)
            ->setType((new AttachmentType())
                ->setType('response_project')
                ->setLabel('Projet de réponse')
                ->setSignable(true))
            ->setDocument($document)
            ->setCreationDate(new DateTimeImmutable())
            ->setModificationDate(new DateTimeImmutable());
        $this->attachmentRepositoryMock->attachmentsInSignatureBookWithAnInternalParapheur = [
            $this->attachmentMock
        ];

        $this->updateWorkflowInSignatureBook = new UpdateWorkflowInSignatureBook(
            $this->signatureServiceConfigLoaderMock,
            $this->signatureBookWorkflowServiceMock,
            $this->userRepositoryMock,
            $this->mainResourceRepositoryMock,
            $this->attachmentRepositoryMock
        );
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testCannotGetSignatureServiceConfigExpectProblem(): void
    {
        $this->signatureServiceConfigLoaderMock->isFileLoaded = false;
        $this->expectException(SignatureBookNoConfigFoundProblem::class);
        $this->updateWorkflowInSignatureBook->update([]);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testGetSignatureServiceJsonConfig(): void
    {
        $this->updateWorkflowInSignatureBook->update([]);
        $this->assertNotEmpty($this->signatureBookWorkflowServiceMock->config);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testCannotGetUserFromListInstanceExpectProblem(): void
    {
        $listInstance = [
            $this->mainResourceRepositoryMock->mainResource->getResId() => [
                [
                    'item_id'   => 10,
                    'item_mode' => 'visa',
                ]
            ]
        ];
        $this->userRepositoryMock->doesUserExist = false;
        $this->expectException(UserDoesNotExistProblem::class);
        $this->updateWorkflowInSignatureBook->update($listInstance);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testCannotGetUserInternalParapheurFromListInstanceExpectProblem(): void
    {
        $listInstance = [
            $this->mainResourceRepositoryMock->mainResource->getResId() => [
                [
                    'item_id'   => 10,
                    'item_mode' => 'visa',
                ]
            ]
        ];
        $this->userRepositoryMock->doesInternalParapheurExist = false;
        $this->expectException(UserIsNotSyncInSignatureBookProblem::class);
        $this->updateWorkflowInSignatureBook->update($listInstance);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testCannotGetUnknownMainResourceExpectProblem(): void
    {
        $listInstance = [
            $this->mainResourceRepositoryMock->mainResource->getResId() => [
                [
                    'item_id'   => 10,
                    'item_mode' => 'visa',
                ]
            ]
        ];
        $this->mainResourceRepositoryMock->mainResource = null;
        $this->expectException(ResourceDoesNotExistProblem::class);
        $this->updateWorkflowInSignatureBook->update($listInstance);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testCannotCheckMainResourceWorkflowExistenceInSignatureBookExpectProblem(): void
    {
        $listInstance = [
            $this->mainResourceRepositoryMock->mainResource->getResId() => [
                [
                    'item_id'   => 10,
                    'item_mode' => 'visa',
                ]
            ]
        ];
        $this->attachmentRepositoryMock->attachmentsInSignatureBookWithAnInternalParapheur = [];
        $this->mainResourceRepositoryMock->mainResource->setExternalDocumentId(1);
        $this->signatureBookWorkflowServiceMock->doesWorkflowExist = false;

        $this->expectException(CheckWorkflowExistenceInSignatureBookProblem::class);

        $this->updateWorkflowInSignatureBook->update($listInstance);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testCannotCheckAttachmentResourceWorkflowExistenceInSignatureBookExpectProblem(): void
    {
        $listInstance = [
            $this->mainResourceRepositoryMock->mainResource->getResId() => [
                [
                    'item_id'   => 10,
                    'item_mode' => 'visa',
                ]
            ]
        ];
        $this->attachmentRepositoryMock->attachmentsInSignatureBookWithAnInternalParapheur = [
            $this->attachmentMock->setExternalDocumentId(2)
        ];
        $this->signatureBookWorkflowServiceMock->doesWorkflowExist = false;

        $this->expectException(CheckWorkflowExistenceInSignatureBookProblem::class);

        $this->updateWorkflowInSignatureBook->update($listInstance);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testCannotUpdateMainResourceWorkflowInSignatureBookExpectProblem(): void
    {
        $listInstance = [
            $this->mainResourceRepositoryMock->mainResource->getResId() => [
                [
                    'item_id'   => 10,
                    'item_mode' => 'visa',
                ]
            ]
        ];
        $this->mainResourceRepositoryMock->mainResource->setExternalDocumentId(1);
        $this->signatureBookWorkflowServiceMock->didWorkflowUpdated = false;

        $this->expectException(CouldNotUpdateWorkflowInSignatureBookProblem::class);

        $this->updateWorkflowInSignatureBook->update($listInstance);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testCannotUpdateAttachmentResourceWorkflowInSignatureBookExpectProblem(): void
    {
        $listInstance = [
            $this->mainResourceRepositoryMock->mainResource->getResId() => [
                [
                    'item_id'   => 10,
                    'item_mode' => 'visa',
                ]
            ]
        ];
        $this->attachmentRepositoryMock->attachmentsInSignatureBookWithAnInternalParapheur = [
            $this->attachmentMock->setExternalDocumentId(2)
        ];
        $this->signatureBookWorkflowServiceMock->didWorkflowUpdated = false;

        $this->expectException(CouldNotUpdateWorkflowInSignatureBookProblem::class);

        $this->updateWorkflowInSignatureBook->update($listInstance);
    }

    /**
     * @return void
     * @throws CheckWorkflowExistenceInSignatureBookProblem
     * @throws CouldNotUpdateWorkflowInSignatureBookProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserDoesNotExistProblem
     * @throws UserIsNotSyncInSignatureBookProblem
     */
    public function testExpectUseUserRoleVisaWhenCannotFindTheUnknownUserRoleInListInstance(): void
    {
        $this->mainResourceRepositoryMock->mainResource->setExternalDocumentId(1);
        $this->attachmentRepositoryMock->attachmentsInSignatureBookWithAnInternalParapheur = [
            $this->attachmentMock->setExternalDocumentId(2)
        ];
        $listInstance = [
            $this->mainResourceRepositoryMock->mainResource->getResId() => [
                [
                    'item_id'   => 10,
                    'item_mode' => 'error',
                ]
            ]
        ];

        $this->updateWorkflowInSignatureBook->update($listInstance);

        $this->assertNotEmpty($this->signatureBookWorkflowServiceMock->workflowsToUpdateInSignatureBook);
        $this->assertArrayHasKey('mode', $this->signatureBookWorkflowServiceMock->workflowsToUpdateInSignatureBook[0]);
        $this->assertSame(
            'visa',
            $this->signatureBookWorkflowServiceMock->workflowsToUpdateInSignatureBook[0]['mode']
        );
        $this->assertSame(
            SignatureMode::STAMP->value,
            $this->signatureBookWorkflowServiceMock->workflowsToUpdateInSignatureBook[0]['signatureMode']
        );
    }
}
