<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief   WebhookValidation test
 * @author  dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application\Webhook;

use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\Attachment\Domain\AttachmentType;
use MaarchCourrier\DocumentStorage\Domain\Document;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Application\Webhook\WebhookValidation;
use MaarchCourrier\SignatureBook\Domain\Problem\AttachmentOutOfPerimeterProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\CurrentTokenIsNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\IdParapheurIsMissingProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\ResourceIdEmptyProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\ResourceIdMasterNotCorrespondingProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\RetrieveDocumentUrlEmptyProblem;
use MaarchCourrier\SignatureBook\Domain\SignedResource;
use MaarchCourrier\Tests\Unit\Attachment\Mock\AttachmentRepositoryMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\CurrentUserInformationsMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\UserRepositoryMock;
use MaarchCourrier\Core\Domain\User\Problem\UserDoesNotExistProblem;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class WebhookValidationTest extends TestCase
{
    private AttachmentRepositoryMock $attachmentRepositoryMock;
    private MainResourceRepositoryMock $mainResourceRepositoryMock;
    private WebhookValidation $webhookValidation;
    private UserRepositoryMock $userRepositoryMock;
    private array $bodySentByMP = [
        'identifier'     => 'TDy3w2zAOM41M216',
        'signatureState' => [
            'error'               => '',
            'state'               => 'VAL',
            'message'             => '',
            'updatedDate'         => "2024-03-01T13:19:59+01:00",
            'hasDigitalSignature' => "true",
            'hasStampSignature'   => "true"
        ],
        'payload'        => [
            'idParapheur' => 30
        ],
        'token'          => 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyZXNfaWQi
                             OjE1OSwidXNlcklkIjoxMH0.olM35fZrHlsYXTRceohEqijjIOqCNolVSbw0v5eKW78',
        'retrieveDocUri' => "http://10.1.5.12/maarch-parapheur-api/rest/documents/11/content?mode=base64&type=esign"
    ];

    private array $decodedToken = [
        'resId'        => 159,
        'userSerialId' => 10
    ];


    protected function setUp(): void
    {
        $this->attachmentRepositoryMock = new AttachmentRepositoryMock();
        $this->mainResourceRepositoryMock = new MainResourceRepositoryMock();

        $this->userRepositoryMock = new UserRepositoryMock();
        $currentUserInformationsMock = new CurrentUserInformationsMock();

        $this->webhookValidation = new WebhookValidation(
            $this->attachmentRepositoryMock,
            $this->mainResourceRepositoryMock,
            $this->userRepositoryMock,
            $currentUserInformationsMock
        );

        $this->user = new User();
        $this->user->setId(1);

        $document = (new Document())
            ->setFileName('the-file.pdf')
            ->setFileExtension('pdf');

        $this->mainResourceRepositoryMock->mainResource = (new MainResource())
            ->setResId(100)
            ->setSubject('Courrier Test')
            ->setTypist($this->user)
            ->setChrono('MAARCH/2024/1')
            ->setDocument($document);

        $this->attachmentRepositoryMock->attachment = $this->makeAttachment($document);
    }

    private function makeAttachment(Document $document) : Attachment
    {
        $signableAttachmentType = (new AttachmentType())
            ->setType('response_project')
            ->setLabel('Projet de réponse')
            ->setSignable(true);

        return (new Attachment())
            ->setChrono('MAARCH/2024D/1000')
            ->setTitle('PDF_Reponse_blocsignature')
            ->setTypist($this->user)
            ->setRecipientId(6)
            ->setRecipientType('contact')
            ->setRelation(1)
            ->setExternalDocumentId(20)
            ->setType($signableAttachmentType);
    }

    protected function tearDown(): void
    {
        $this->bodySentByMP = [
            'identifier'     => 'TDy3w2zAOM41M216',
            'signatureState' => [
                'error'               => '',
                'state'               => 'VAL',
                'message'             => '',
                'updatedDate'         => "2024-03-01T13:19:59+01:00",
                'hasDigitalSignature' => "true",
                'hasStampSignature'   => "true"
            ],
            'payload'        => [
                'idParapheur' => 30
            ],
            'token'          => 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyZXNfaWQiOjE1O
                                 SwidXNlcklkIjoxMH0.olM35fZrHlsYXTRceohEqijjIOqCNolVSbw0v5eKW78',
            'retrieveDocUri' => "http://10.1.5.12/maarch-parapheur-api/rest/documents/11/content?mode=base64&type=esign"
        ];


        $this->attachmentRepositoryMock->attachmentNotExists = false;
        $this->attachmentRepositoryMock->resIdConcordingWithResIdMaster = true;
    }


    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws UserDoesNotExistProblem
     */
    public function testValidationSuccessIfAllParametersAreSetAndValid(): void
    {
        $this->decodedToken = [
            'resId'        => 159,
            'resIdMaster'  => 75,
            'userSerialId' => 10
        ];
        $signedResource = $this->webhookValidation->validateAndCreateResource($this->bodySentByMP, $this->decodedToken);
        $this->assertInstanceOf(SignedResource::class, $signedResource);
        $this->assertSame($signedResource->getResIdSigned(), $this->decodedToken['resId']);
        $this->assertSame($signedResource->getResIdMaster(), $this->decodedToken['resIdMaster']);
        $this->assertSame($signedResource->getStatus(), $this->bodySentByMP['signatureState']['state']);
        $this->assertTrue($signedResource->getHasDigitalSignature());
        $this->assertTrue($signedResource->getHasStampSignature());
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws UserDoesNotExistProblem
     */
    public function testValidationErrorIfRetrieveUrlIsEmpty(): void
    {
        $this->bodySentByMP['retrieveDocUri'] = '';
        $this->expectException(RetrieveDocumentUrlEmptyProblem::class);
        $this->webhookValidation->validateAndCreateResource($this->bodySentByMP, $this->decodedToken);
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws UserDoesNotExistProblem
     */
    public function testValidationErrorIfResIdIsMissing(): void
    {
        unset($this->decodedToken['resId']);
        $this->expectException(ResourceIdEmptyProblem::class);
        $this->webhookValidation->validateAndCreateResource($this->bodySentByMP, $this->decodedToken);
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws UserDoesNotExistProblem
     */
    public function testValidationErrorIfResIdNotCorrespondingToResIdMaster(): void
    {
        $this->decodedToken = [
            'resId'        => 159,
            'resIdMaster'  => 75,
            'userSerialId' => 10
        ];

        $this->attachmentRepositoryMock->resIdConcordingWithResIdMaster = false;

        $this->expectException(ResourceIdMasterNotCorrespondingProblem::class);
        $this->webhookValidation->validateAndCreateResource($this->bodySentByMP, $this->decodedToken);
    }

    /**
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws UserDoesNotExistProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     */
    public function testValidationErrorIfAttachmentNotInPerimeter(): void
    {
        $this->decodedToken = [
            'resId'        => 159,
            'resIdMaster'  => 75,
            'userSerialId' => 10
        ];

        $this->attachmentRepositoryMock->attachmentNotExists = true;

        $this->expectException(AttachmentOutOfPerimeterProblem::class);
        $this->webhookValidation->validateAndCreateResource($this->bodySentByMP, $this->decodedToken);
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     */
    public function testValidationErrorIfUserNotExists(): void
    {
        $this->userRepositoryMock->doesUserExist = false;
        $this->expectException(UserDoesNotExistProblem::class);
        $this->webhookValidation->validateAndCreateResource($this->bodySentByMP, $this->decodedToken);
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws UserDoesNotExistProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     */
    public function testValidationErrorIfTokenIsNotSet(): void
    {
        unset($this->bodySentByMP['token']);
        $this->expectException(CurrentTokenIsNotFoundProblem::class);
        $this->webhookValidation->validateAndCreateResource($this->bodySentByMP, $this->decodedToken);
    }

    /**
     * @return void
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws UserDoesNotExistProblem
     */
    public function testValidationErrorIfIdParapheurIsNotSet(): void
    {
        unset($this->bodySentByMP['payload']['idParapheur']);
        $this->expectException(IdParapheurIsMissingProblem::class);
        $this->webhookValidation->validateAndCreateResource($this->bodySentByMP, $this->decodedToken);
    }
}
