<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief   WebhookCall test
 * @author  dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application\Webhook\UseCase;

use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Application\Webhook\RetrieveSignedResource;
use MaarchCourrier\SignatureBook\Application\Webhook\StoreSignedResource;
use MaarchCourrier\SignatureBook\Application\Webhook\UseCase\WebhookCall;
use MaarchCourrier\SignatureBook\Application\Webhook\WebhookValidation;
use MaarchCourrier\SignatureBook\Domain\Problem\AttachmentOutOfPerimeterProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\CurrentTokenIsNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\NoEncodedContentRetrievedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\ResourceIdEmptyProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\ResourceIdMasterNotCorrespondingProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\RetrieveDocumentUrlEmptyProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\StoreResourceProblem;
use MaarchCourrier\Tests\Unit\Attachment\Mock\AttachmentRepositoryMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\MaarchParapheurSignatureServiceMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\CurrentUserInformationsMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Repository\VisaWorkflowRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\UserRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Webhook\ResourceToSignRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Webhook\SignatureHistoryServiceSpy;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Webhook\StoreSignedResourceServiceMock;
use MaarchCourrier\Core\Domain\User\Problem\UserDoesNotExistProblem;
use PHPUnit\Framework\TestCase;

class WebhookCallTest extends TestCase
{
    private WebhookCall $webhookCall;

    private SignatureHistoryServiceSpy $historyService;

    private array $bodySentByMP = [
        'identifier'     => 'TDy3w2zAOM41M216',
        'signatureState' => [
            'error'               => '',
            'state'               => 'VAL',
            'message'             => '',
            'updatedDate'         => null
        ],
        'payload'        => [
            'idParapheur' => 30
        ],
        'token'          => 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyZXNfaWQiOjE1OSwidXNlcklkIjoxMH0.olM35fZrHlsYXTRceohEqijjIOqCNolVSbw0v5eKW78',
        'retrieveDocUri' => "https://192.168.1.151/maarch-parapheur-api/rest/documents/11/content?mode=base64&type=esign"
    ];

    private array $decodedToken = [
        'resId'        => 159,
        'userSerialId' => 10
    ];

    protected function setUp(): void
    {
        $currentUserInformations = new CurrentUserInformationsMock();
        $resourceToSignRepository = new ResourceToSignRepositoryMock();
        $attachmentRepository = new AttachmentRepositoryMock();
        $mainResourceRepository = new MainResourceRepositoryMock();
        $visaWorkflowRepository = new VisaWorkflowRepositoryMock();
        $storeSignedResourceService = new StoreSignedResourceServiceMock();
        $this->historyService = new SignatureHistoryServiceSpy();
        $userRepository = new UserRepositoryMock();
        $maarchParapheurSignatureService = new MaarchParapheurSignatureServiceMock();

        $mainResourceRepository->mainResource = (new MainResource());
        $webhookValidation = new WebhookValidation(
            $attachmentRepository, $mainResourceRepository, $userRepository, $currentUserInformations
        );
        $retrieveSignedResource = new RetrieveSignedResource(
            $currentUserInformations, $maarchParapheurSignatureService
        );
        $storeSignedResource = new StoreSignedResource(
            $resourceToSignRepository,
            $storeSignedResourceService,
            $attachmentRepository,
            $mainResourceRepository,
            $visaWorkflowRepository
        );

        $this->webhookCall = new WebhookCall(
            $webhookValidation,
            $retrieveSignedResource,
            $storeSignedResource,
            $this->historyService
        );
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws StoreResourceProblem
     * @throws UserDoesNotExistProblem
     * @throws NoEncodedContentRetrievedProblem
     */
    public function testWebhookCallSuccessIfSignatureParametersAreNotSet(): void
    {
        $return = $this->webhookCall->execute($this->bodySentByMP, $this->decodedToken);
        $this->assertTrue($this->historyService->addedInHistoryValidation);
        $this->assertIsInt($return);
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws StoreResourceProblem
     * @throws UserDoesNotExistProblem
     * @throws NoEncodedContentRetrievedProblem
     */
    public function testWebhookCallSuccessIfSignatureParametersAreSet(): void
    {
        $this->bodySentByMP['signatureState']['hasDigitalSignature'] = true;
        $this->bodySentByMP['signatureState']['hasStampSignature'] = true;

        $return = $this->webhookCall->execute($this->bodySentByMP, $this->decodedToken);
        $this->assertTrue($this->historyService->addedInHistoryValidation);
        $this->assertIsInt($return);
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws NoEncodedContentRetrievedProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws StoreResourceProblem
     * @throws UserDoesNotExistProblem
     */
    public function testWebhookCallSuccessAndStoreInHistoryIfRefusState(): void
    {
        $this->bodySentByMP['signatureState']['state'] = 'REF';
        $this->bodySentByMP['signatureState']['message'] = 'Tout est pas ok';

        $return = $this->webhookCall->execute($this->bodySentByMP, $this->decodedToken);
        $this->assertTrue($this->historyService->addedInHistoryRefus);
        $this->assertIsArray($return);
        $this->assertSame(
            $return['message'],
            'Status of signature is ' .
            $this->bodySentByMP['signatureState']['state'] . " : " . $this->bodySentByMP['signatureState']['message']
        );
    }

    /**
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws NoEncodedContentRetrievedProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws StoreResourceProblem
     * @throws UserDoesNotExistProblem
     */
    public function testWebhookCallSuccessAndStoreInHistoryIfErrorState(): void
    {
        $this->bodySentByMP['signatureState']['state'] = 'ERROR';
        $this->bodySentByMP['signatureState']['error'] = 'Error during signature';

        $return = $this->webhookCall->execute($this->bodySentByMP, $this->decodedToken);
        $this->assertTrue($this->historyService->addedInHistoryError);
        $this->assertIsArray($return);
        $this->assertSame(
            $return['message'],
            'Status of signature is ' .
            $this->bodySentByMP['signatureState']['state'] . " : " . $this->bodySentByMP['signatureState']['error']
        );
    }
}
