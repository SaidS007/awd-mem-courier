<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Basket Repository class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Basket\Infrastructure\Repository;

use Basket\models\BasketModel;
use Exception;
use MaarchCourrier\Basket\Domain\Basket;
use MaarchCourrier\Core\Domain\Basket\Port\BasketInterface;
use MaarchCourrier\Core\Domain\Basket\Port\BasketRepositoryInterface;

class BasketRepository implements BasketRepositoryInterface
{
    /**
     * @param int $id
     *
     * @return BasketInterface|null
     * @throws Exception
     */
    public function getBasketById(int $id): BasketInterface|null
    {
        $basket = BasketModel::get([
            'select' => ['*'],
            'where' => ['id = ?'],
            'data' => [$id]
        ]);

        if (empty($basket)) {
            return null;
        }

        return (new Basket())
            ->setId($id)
            ->setClause($basket[0]['basket_clause']);
    }
}
