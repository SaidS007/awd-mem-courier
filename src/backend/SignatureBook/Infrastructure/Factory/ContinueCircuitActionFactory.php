<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief ContinueCircuitActionFactory class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Infrastructure\Factory;

use Exception;
use MaarchCourrier\Attachment\Infrastructure\Repository\AttachmentRepository;
use MaarchCourrier\Core\Infrastructure\Environment;
use MaarchCourrier\MainResource\Infrastructure\Repository\MainResourceRepository;
use MaarchCourrier\SignatureBook\Application\Action\ContinueCircuitAction;
use MaarchCourrier\SignatureBook\Application\Workflow\UpdateWorkflowInSignatureBook;
use MaarchCourrier\SignatureBook\Infrastructure\MaarchParapheurSignatureService;
use MaarchCourrier\SignatureBook\Infrastructure\Repository\VisaWorkflowRepository;
use MaarchCourrier\SignatureBook\Infrastructure\Service\SignatureBookWorkflowService;
use MaarchCourrier\SignatureBook\Infrastructure\SignatureServiceJsonConfigLoader;
use MaarchCourrier\User\Infrastructure\CurrentUserInformations;
use MaarchCourrier\User\Infrastructure\Repository\UserRepository;
use MaarchCourrier\User\Infrastructure\UserFactory;

class ContinueCircuitActionFactory
{
    /**
     * @throws Exception
     */
    public static function create(): ContinueCircuitAction
    {
        $currentUser = new CurrentUserInformations();
        $signatureService = new MaarchParapheurSignatureService();
        $isNewInternalParapheurEnabled = new Environment();
        $isNewInternalParapheurEnabled = $isNewInternalParapheurEnabled->isNewInternalParapheurEnabled();
        $signatureServiceConfigLoader = new SignatureServiceJsonConfigLoader();

        $userFactory = new UserFactory();
        $userRepository = new UserRepository();
        $mainResourceRepository = new MainResourceRepository($userRepository);
        $visaWorkflowRepository = new VisaWorkflowRepository($userFactory);
        $updateWorkflowInSignatureBook = new UpdateWorkflowInSignatureBook(
            $signatureServiceConfigLoader,
            new SignatureBookWorkflowService(),
            $userRepository,
            $mainResourceRepository,
            new AttachmentRepository(
                $userRepository,
                $mainResourceRepository
            )
        );

        return new ContinueCircuitAction(
            $currentUser,
            $signatureService,
            $signatureServiceConfigLoader,
            $mainResourceRepository,
            $visaWorkflowRepository,
            $isNewInternalParapheurEnabled,
            $updateWorkflowInSignatureBook
        );
    }
}
