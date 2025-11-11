<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 */

/**
 * @brief Delete Substitute In Signatory Book Factory
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Infrastructure\Factory\User;

use MaarchCourrier\SignatureBook\Application\User\DeleteSubstituteInSignatoryBook;
use MaarchCourrier\SignatureBook\Infrastructure\MaarchParapheurUserService;
use MaarchCourrier\SignatureBook\Infrastructure\SignatureServiceJsonConfigLoader;

class DeleteSubstituteInSignatoryBookFactory
{
    public function create(): DeleteSubstituteInSignatoryBook
    {
        $signatureBookUser = new MaarchParapheurUserService();
        $signatureBookConfigLoader = new SignatureServiceJsonConfigLoader();

        return new DeleteSubstituteInSignatoryBook(
            $signatureBookUser,
            $signatureBookConfigLoader
        );
    }
}
