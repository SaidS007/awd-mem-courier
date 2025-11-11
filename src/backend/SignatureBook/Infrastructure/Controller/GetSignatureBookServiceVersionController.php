<?php

declare(strict_types=1);

namespace MaarchCourrier\SignatureBook\Infrastructure\Controller;

use MaarchCourrier\SignatureBook\Application\GetSignatureBookServiceVersion;
use MaarchCourrier\SignatureBook\Infrastructure\Factory\GetSignatureBookServiceVersionFactory;
use Slim\Psr7\Request;
use SrcCore\http\Response;

class GetSignatureBookServiceVersionController
{
    public function __construct(
        private ?GetSignatureBookServiceVersion $getSignatureBookServiceVersion = null
    ) {
    }

    public function getVersion(Request $request, Response $response): Response
    {
        if ($this->getSignatureBookServiceVersion === null) {
            $this->getSignatureBookServiceVersion = GetSignatureBookServiceVersionFactory::create();
        }

        return $response->withJson(
            $this->getSignatureBookServiceVersion->execute()
        );
    }
}
