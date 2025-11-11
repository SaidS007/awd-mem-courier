<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 */

/**
 * @brief Add Substitute In Signatory Book Factory
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Infrastructure\Factory\User;


use MaarchCourrier\Basket\Infrastructure\Repository\RedirectBasketRepository;
use MaarchCourrier\SignatureBook\Application\User\AddSubstituteInSignatoryBook;
use MaarchCourrier\SignatureBook\Infrastructure\MaarchParapheurUserService;
use MaarchCourrier\SignatureBook\Infrastructure\SignatureServiceJsonConfigLoader;
use MaarchCourrier\User\Infrastructure\Repository\UserRepository;

class AddSubstituteInSignatoryBookFactory
{
    public function create(): AddSubstituteInSignatoryBook
    {
        $signatureBookUser = new MaarchParapheurUserService();
        $signatureBookConfigLoader = new SignatureServiceJsonConfigLoader();
        $redirectBasketRepository = new RedirectBasketRepository();
        $userRepository = new UserRepository();

        return new AddSubstituteInSignatoryBook(
            $signatureBookUser,
            $signatureBookConfigLoader,
            $redirectBasketRepository,
            $userRepository
        );
    }
}
