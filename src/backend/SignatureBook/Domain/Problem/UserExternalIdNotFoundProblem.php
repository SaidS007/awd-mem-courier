<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 */

/**
 * @brief User External Id Not Found Problem
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Domain\Problem;

use MaarchCourrier\Core\Domain\Problem\Problem;

class UserExternalIdNotFoundProblem extends Problem
{
    public function __construct()
    {
        parent::__construct(
            "The user is not synchronized with the signature book",
            500,
            lang: 'userGroupNotSynchronizedWithSignatureBook',
        );
    }
}
