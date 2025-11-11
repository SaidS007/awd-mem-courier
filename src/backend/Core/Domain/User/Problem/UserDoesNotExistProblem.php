<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief User Does Not Exist Problem
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Core\Domain\User\Problem;

use MaarchCourrier\Core\Domain\Problem\Problem;

class UserDoesNotExistProblem extends Problem
{
    public function __construct(?int $userId = null)
    {
        $message = empty($userId) ? "User does not exist" : "User '$userId' does not exist";
        parent::__construct(
            $message,
            400,
            [
                'userId' => $userId
            ]
        );
    }
}
