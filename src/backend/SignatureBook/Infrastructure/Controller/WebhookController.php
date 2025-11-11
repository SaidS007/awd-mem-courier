<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Webhook Controller
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Infrastructure\Controller;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use MaarchCourrier\Attachment\Infrastructure\Repository\AttachmentRepository;
use MaarchCourrier\MainResource\Infrastructure\Repository\MainResourceRepository;
use MaarchCourrier\SignatureBook\Application\Webhook\RetrieveSignedResource;
use MaarchCourrier\SignatureBook\Application\Webhook\StoreSignedResource;
use MaarchCourrier\SignatureBook\Application\Webhook\UseCase\WebhookCall;
use MaarchCourrier\SignatureBook\Application\Webhook\WebhookValidation;
use MaarchCourrier\SignatureBook\Domain\Problem\AttachmentOutOfPerimeterProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\CurrentTokenIsNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\NoEncodedContentRetrievedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\ResourceAlreadySignProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\ResourceIdEmptyProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\ResourceIdMasterNotCorrespondingProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\RetrieveDocumentUrlEmptyProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\StoreResourceProblem;
use MaarchCourrier\SignatureBook\Infrastructure\MaarchParapheurSignatureService;
use MaarchCourrier\SignatureBook\Infrastructure\Repository\ResourceToSignRepository;
use MaarchCourrier\SignatureBook\Infrastructure\Repository\VisaWorkflowRepository;
use MaarchCourrier\SignatureBook\Infrastructure\SignatureHistoryService;
use MaarchCourrier\SignatureBook\Infrastructure\StoreSignedResourceService;
use MaarchCourrier\Core\Domain\User\Problem\UserDoesNotExistProblem;
use MaarchCourrier\User\Infrastructure\CurrentUserInformations;
use MaarchCourrier\User\Infrastructure\Repository\UserRepository;
use MaarchCourrier\User\Infrastructure\UserFactory;
use Slim\Psr7\Request;
use SrcCore\http\Response;
use SrcCore\models\CoreConfigModel;
use stdClass;

class WebhookController
{
    /**
     * @param  Request  $request
     * @param  Response  $response
     * @param  array  $args
     * @return Response
     * @throws AttachmentOutOfPerimeterProblem
     * @throws CurrentTokenIsNotFoundProblem
     * @throws ResourceAlreadySignProblem
     * @throws ResourceIdEmptyProblem
     * @throws ResourceIdMasterNotCorrespondingProblem
     * @throws RetrieveDocumentUrlEmptyProblem
     * @throws StoreResourceProblem
     * @throws UserDoesNotExistProblem
     * @throws NoEncodedContentRetrievedProblem
     */
    public function fetchAndStoreSignedDocumentOnWebhookTrigger(
        Request $request,
        Response $response,
        array $args
    ): Response {
        $body = $request->getParsedBody();

        $headers = new stdClass();
        $headers->headers = ['HS256'];
        $encryptKey = CoreConfigModel::getEncryptKey();
        $key = new Key($encryptKey, 'HS256');
        $decodedToken = (!empty($body['token'])) ? (array)JWT::decode(
            $body['token'],
            $key,
            $headers
        ) : [];

        //Initialisation
        $userRepository = new UserRepository();
        $userFactory = new UserFactory();
        $currentUserInformations = new CurrentUserInformations();
        $resourceToSignRepository = new ResourceToSignRepository();
        $attachmentRepository = new AttachmentRepository(
            $userRepository,
            new MainResourceRepository($userRepository)
        );
        $mainResourceRepository = new MainResourceRepository($userRepository);
        $visaWorkflowRepository = new VisaWorkflowRepository($userFactory);

        $storeSignedResourceService = new StoreSignedResourceService();
        $signatureHistoryService = new SignatureHistoryService();
        $maarchParapheurSignatureService = new MaarchParapheurSignatureService();

        $webhookValidation = new WebhookValidation(
            $attachmentRepository,
            $mainResourceRepository,
            $userRepository,
            $currentUserInformations
        );
        $retrieveSignedResource = new RetrieveSignedResource(
            $currentUserInformations,
            $maarchParapheurSignatureService
        );
        $storeSignedResource = new StoreSignedResource(
            $resourceToSignRepository,
            $storeSignedResourceService,
            $attachmentRepository,
            $mainResourceRepository,
            $visaWorkflowRepository
        );

        $webhookCall = new WebhookCall(
            $webhookValidation,
            $retrieveSignedResource,
            $storeSignedResource,
            $signatureHistoryService
        );

        $result = $webhookCall->execute($body, $decodedToken);
        return $response->withJson((is_int($result)) ? ['id' => $result] : $result);
    }
}
