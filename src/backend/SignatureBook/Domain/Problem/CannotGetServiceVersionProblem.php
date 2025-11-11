<?php

declare(strict_types=1);

namespace MaarchCourrier\SignatureBook\Domain\Problem;

use MaarchCourrier\Core\Domain\Problem\Problem;

class CannotGetServiceVersionProblem extends Problem
{
    public function __construct(string $reason)
    {
        parent::__construct(
            "Cannot get parapheur version : $reason",
            400,
            context: [
                'reason' => $reason
            ]
        );
    }
}
