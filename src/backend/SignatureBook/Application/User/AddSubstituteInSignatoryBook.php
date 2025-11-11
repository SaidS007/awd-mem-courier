<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Add Substitute In Signatory Book
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Application\User;

use Exception;
use MaarchCourrier\Basket\Infrastructure\Repository\RedirectBasketRepository;
use MaarchCourrier\Core\Domain\User\Port\UserInterface;
use MaarchCourrier\SignatureBook\Domain\Port\SignatureBookUserServiceInterface;
use MaarchCourrier\SignatureBook\Domain\Port\SignatureServiceConfigLoaderInterface;
use MaarchCourrier\SignatureBook\Domain\Problem\AddSubstituteInSignatoryBookProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\UserExternalIdNotFoundProblem;
use MaarchCourrier\User\Infrastructure\Repository\UserRepository;

class AddSubstituteInSignatoryBook
{
    /**
     * @param SignatureBookUserServiceInterface $signatureBookUserService
     * @param SignatureServiceConfigLoaderInterface $signatureServiceConfigLoader
     * @param RedirectBasketRepository $redirectBasketRepository
     * @param UserRepository $userRepository
     */
    public function __construct(
        private readonly SignatureBookUserServiceInterface $signatureBookUserService,
        private readonly SignatureServiceConfigLoaderInterface $signatureServiceConfigLoader,
        private readonly RedirectBasketRepository $redirectBasketRepository,
        private readonly UserRepository $userRepository
    ) {
    }

    /**
     * @param UserInterface $targetUser
     * @param UserInterface $substitute
     * @return void
     * @throws AddSubstituteInSignatoryBookProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserExternalIdNotFoundProblem
     * @throws Exception
     */
    public function addSubstitute(UserInterface $targetUser, UserInterface $substitute): void
    {
        $signatureBook = $this->signatureServiceConfigLoader->getSignatureServiceConfig();
        if ($signatureBook === null) {
            throw new SignatureBookNoConfigFoundProblem();
        }
        $this->signatureBookUserService->setConfig($signatureBook);

        if (!empty($targetUser->getInternalParapheur()) && !empty($substitute->getInternalParapheur())) {
            $basketRedirectedToOwner = $this->redirectBasketRepository->getRedirectedBasketsByUser($targetUser);
            $substitutionAlreadyExists = false;

            $tabSubstitutionUsers = [];
            foreach ($basketRedirectedToOwner as $redirectBasket) {
                $tabSubstitutionUsers[] = $redirectBasket['actual_user_id'];
            }

            $nbOccurrences = array_count_values($tabSubstitutionUsers);
            if (isset($nbOccurrences[$substitute->getId()])) {
                $substitutionAlreadyExists = true;
            }
            //TODO supprimer l'utilisateur si la redirection multiple si il n'y a pas d'autres bannettes liées

            if (!$substitutionAlreadyExists) {
                $isSubstituteAdded = $this->signatureBookUserService->addSubstitute($targetUser, $substitute);
                if (!empty($isSubstituteAdded['errors'])) {
                    throw new AddSubstituteInSignatoryBookProblem($isSubstituteAdded);
                }
            }
        } else {
            throw new UserExternalIdNotFoundProblem();
        }
    }
}
