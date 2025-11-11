<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Basket Clause Service Mock class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\Basket\Mock;

use MaarchCourrier\Core\Domain\Basket\Port\BasketClauseServiceInterface;
use MaarchCourrier\Core\Domain\Basket\Port\BasketInterface;
use MaarchCourrier\Core\Domain\User\Port\UserInterface;

class BasketClauseServiceMock implements BasketClauseServiceInterface
{
    public bool $didPastInPrepareFunction = false;

    public function prepare(BasketInterface $basket, UserInterface $user): string
    {
        $this->didPastInPrepareFunction = true;
        return '';
    }
}
