<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Basket Class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Basket\Domain;

use MaarchCourrier\Core\Domain\Basket\Port\BasketInterface;

class Basket implements BasketInterface
{
    private int $id;
    private string $clause = '';

    public function getId(): int
    {
        return $this->id;
    }

    public function setId(int $id): BasketInterface
    {
        $this->id = $id;
        return $this;
    }

    public function getClause(): string
    {
        return $this->clause;
    }

    public function setClause(string $clause): BasketInterface
    {
        $this->clause = $clause;
        return $this;
    }
}
