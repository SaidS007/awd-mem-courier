<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Perform Action Checker Test class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\Basket\Mock;

use MaarchCourrier\Core\Domain\Basket\Port\BasketInterface;
use MaarchCourrier\Core\Domain\Basket\Port\RedirectBasketRepositoryInterface;
use MaarchCourrier\Core\Domain\Group\Port\GroupInterface;
use MaarchCourrier\Core\Domain\User\Port\UserInterface;

class RedirectBasketRepositoryMock implements RedirectBasketRepositoryInterface
{
    public bool $isBasketAssignedToUserOfGroup = false;

    public function isBasketAssignedToUserOfGroup(
        UserInterface $basketOwner,
        UserInterface $connectedUser,
        GroupInterface $group,
        BasketInterface $basket
    ): bool {
        return $this->isBasketAssignedToUserOfGroup;
    }
}
