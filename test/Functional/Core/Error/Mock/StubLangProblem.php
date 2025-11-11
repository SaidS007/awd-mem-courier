<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 */

/**
 * @brief StubLangProblem
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Functional\Core\Error\Mock;

use MaarchCourrier\Core\Domain\Problem\Problem;

class StubLangProblem extends Problem
{
    /**
     * @param string $value
     */
    public function __construct(string $value)
    {
        parent::__construct(
            'My custom problem : ' . $value,
            418,
            [
                'value' => $value
            ],
            'toto'
        );
    }
}
