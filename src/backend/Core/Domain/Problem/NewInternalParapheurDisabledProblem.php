<?php

declare(strict_types=1);

namespace MaarchCourrier\Core\Domain\Problem;

class NewInternalParapheurDisabledProblem extends Problem
{
    public function __construct()
    {
        parent::__construct('New internal parapher is disabled', 400);
    }
}
