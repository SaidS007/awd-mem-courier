<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Group Does Not Exist Problem class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Group\Domain\Problem;

use MaarchCourrier\Core\Domain\Problem\Problem;

class GroupDoesNotExistProblem extends Problem
{
    public function __construct()
    {
        parent::__construct("Group does not exist", 400);
    }
}
