<?php

namespace MaarchCourrier\SignatureBook\Infrastructure\Factory;

use Exception;
use MaarchCourrier\Attachment\Infrastructure\Repository\AttachmentRepository;
use MaarchCourrier\Core\Infrastructure\Environment;
use MaarchCourrier\MainResource\Infrastructure\Repository\MainResourceRepository;
use MaarchCourrier\SignatureBook\Application\Action\InterruptCircuitAction;
use MaarchCourrier\SignatureBook\Infrastructure\MaarchParapheurSignatureService;
use MaarchCourrier\SignatureBook\Infrastructure\SignatureServiceJsonConfigLoader;
use MaarchCourrier\User\Infrastructure\CurrentUserInformations;
use MaarchCourrier\User\Infrastructure\Repository\UserRepository;

class InterruptCircuitActionFactory
{
    /**
     * @return InterruptCircuitAction
     * @throws Exception
     */
    public static function create(): InterruptCircuitAction
    {
        $userRepository = new UserRepository();
        $mainResourceRepository = new MainResourceRepository($userRepository);
        $attachmentRepository = new AttachmentRepository($userRepository, $mainResourceRepository);

        return new InterruptCircuitAction(
            new CurrentUserInformations(),
            $mainResourceRepository,
            $attachmentRepository,
            new MaarchParapheurSignatureService(),
            new SignatureServiceJsonConfigLoader(),
            (new Environment())->isNewInternalParapheurEnabled()
        );
    }
}
