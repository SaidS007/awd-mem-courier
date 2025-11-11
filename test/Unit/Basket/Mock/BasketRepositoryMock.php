<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Basket Repository Mock class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\Basket\Mock;

use MaarchCourrier\Basket\Domain\Basket;
use MaarchCourrier\Core\Domain\Basket\Port\BasketInterface;
use MaarchCourrier\Core\Domain\Basket\Port\BasketRepositoryInterface;

class BasketRepositoryMock implements BasketRepositoryInterface
{
    public bool $doesBasketExist = true;
    public ?BasketInterface $basket;

    public function getBasketById(int $id): BasketInterface|null
    {
        if (!$this->doesBasketExist) {
            return null;
        }

        if (!empty($this->basket)) {
            return $this->basket;
        }

        return (new Basket())
            ->setId($id);
    }
}
