<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief RejectVisaBackToPreviousActionFactory Class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Infrastructure\Factory;

use Exception;
use MaarchCourrier\Attachment\Infrastructure\Repository\AttachmentRepository;
use MaarchCourrier\Core\Infrastructure\Environment;
use MaarchCourrier\MainResource\Infrastructure\Repository\MainResourceRepository;
use MaarchCourrier\SignatureBook\Application\Action\RejectVisaBackToPreviousAction;
use MaarchCourrier\SignatureBook\Infrastructure\MaarchParapheurSignatureService;
use MaarchCourrier\SignatureBook\Infrastructure\SignatureServiceJsonConfigLoader;
use MaarchCourrier\User\Infrastructure\CurrentUserInformations;
use MaarchCourrier\User\Infrastructure\Repository\UserRepository;

class RejectVisaBackToPreviousActionFactory
{
    /**
     * @return RejectVisaBackToPreviousAction
     * @throws Exception
     */
    public static function create(): RejectVisaBackToPreviousAction
    {
        $userRepository = new UserRepository();
        $mainResourceRepository = new MainResourceRepository($userRepository);
        $attachmentRepository = new AttachmentRepository($userRepository, $mainResourceRepository);

        return (new RejectVisaBackToPreviousAction(
            new CurrentUserInformations(),
            $mainResourceRepository,
            $attachmentRepository,
            new MaarchParapheurSignatureService(),
            new SignatureServiceJsonConfigLoader(),
            (new Environment())->isNewInternalParapheurEnabled()
        ));
    }
}
