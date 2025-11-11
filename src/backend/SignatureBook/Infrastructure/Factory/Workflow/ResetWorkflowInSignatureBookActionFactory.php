<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Reset Workflow In Signature Book Factory
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Infrastructure\Factory\Workflow;

use MaarchCourrier\Attachment\Infrastructure\Repository\AttachmentRepository;
use MaarchCourrier\Core\Infrastructure\Environment;
use MaarchCourrier\MainResource\Infrastructure\Repository\MainResourceRepository;
use MaarchCourrier\SignatureBook\Application\Action\ResetWorkflowInSignatureBookAction;
use MaarchCourrier\SignatureBook\Infrastructure\Repository\VisaWorkflowRepository;
use MaarchCourrier\SignatureBook\Infrastructure\Service\SignatureBookLinkService;
use MaarchCourrier\SignatureBook\Infrastructure\Service\SignatureBookWorkflowService;
use MaarchCourrier\SignatureBook\Infrastructure\SignatureServiceJsonConfigLoader;
use MaarchCourrier\User\Infrastructure\Repository\UserRepository;
use MaarchCourrier\User\Infrastructure\UserFactory;

class ResetWorkflowInSignatureBookActionFactory
{
    public function create(): ResetWorkflowInSignatureBookAction
    {
        $mainResourceRepository = new MainResourceRepository(new UserRepository());
        $attachmentRepository = new AttachmentRepository(
            new UserRepository(),
            $mainResourceRepository
        );
        $signatureBookWorkflowService = new SignatureBookWorkflowService();

        return new ResetWorkflowInSignatureBookAction(
            new Environment(),
            new SignatureServiceJsonConfigLoader(),
            $signatureBookWorkflowService,
            new VisaWorkflowRepository(new UserFactory()),
            $mainResourceRepository,
            $attachmentRepository,
            new SignatureBookLinkService(
                $signatureBookWorkflowService,
                $mainResourceRepository,
                $attachmentRepository
            )
        );
    }
}
