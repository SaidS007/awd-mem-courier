<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Add User To A Group In Signatory Book Test
 */

namespace Unit\SignatureBook\Application\User;

use MaarchCourrier\Group\Domain\Group;
use MaarchCourrier\SignatureBook\Application\User\AddUserToAGroupInSignatoryBook;
use MaarchCourrier\SignatureBook\Domain\Problem\AddUserToAGroupInSignatoryBookFailedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\GroupExternalIdNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\UserExternalIdNotFoundProblem;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\SignatureServiceJsonConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\User\MaarchParapheurUserServiceMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class AddUserToAGroupInSignatoryBookTest extends TestCase
{
    private MaarchParapheurUserServiceMock $signatureBookUserServiceMock;
    private SignatureServiceJsonConfigLoaderMock $signatureServiceJsonConfigLoaderMock;
    private AddUserToAGroupInSignatoryBook $addUserToAGroupInSignatoryBook;

    protected function setup(): void
    {
        $this->signatureBookUserServiceMock = new MaarchParapheurUserServiceMock();
        $this->signatureServiceJsonConfigLoaderMock = new SignatureServiceJsonConfigLoaderMock();
        $this->addUserToAGroupInSignatoryBook = new AddUserToAGroupInSignatoryBook(
            $this->signatureBookUserServiceMock,
            $this->signatureServiceJsonConfigLoaderMock
        );
    }

    /**
     * @return void
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     * @throws GroupExternalIdNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserExternalIdNotFoundProblem
     */
    public function testAddUserToGroupSuccessfully(): void
    {
        $groupExternalId['internalParapheur'] = 5;
        $userExternalId['internalParapheur'] = 15;

        $group = (new Group())->setExternalId($groupExternalId);
        $user = (new User())->setExternalId($userExternalId);

        $this->addUserToAGroupInSignatoryBook->addUserToGroup($user, $group);

        $this->assertTrue($this->signatureBookUserServiceMock->addUserToGroupIsCalled);
    }


    /**
     * @throws GroupExternalIdNotFoundProblem
     * @throws UserExternalIdNotFoundProblem
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     */
    public function testThrowsProblemWhenSignatureBookConfigNotFound(): void
    {
        $this->signatureServiceJsonConfigLoaderMock->signatureServiceConfigLoader = null;

        $group = new Group();
        $user = new User();

        $this->expectException(SignatureBookNoConfigFoundProblem::class);

        $this->addUserToAGroupInSignatoryBook->addUserToGroup($user, $group);
    }


    /**
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserExternalIdNotFoundProblem
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     */
    public function testThrowsProblemWhenGroupExternalIdNotFound(): void
    {
        $user = new User();
        $group = (new Group())->setExternalId([]);

        $this->expectException(GroupExternalIdNotFoundProblem::class);

        $this->addUserToAGroupInSignatoryBook->addUserToGroup($user, $group);
    }

    /**
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserExternalIdNotFoundProblem
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     * @throws GroupExternalIdNotFoundProblem
     */
    public function testThrowsProblemWhenUserExternalIdNotFound(): void
    {
        $groupExternalId['internalParapheur'] = 5;
        $user = new User();
        $group = (new Group())->setExternalId($groupExternalId);

        $this->expectException(UserExternalIdNotFoundProblem::class);

        $this->addUserToAGroupInSignatoryBook->addUserToGroup($user, $group);
    }


    /**
     * @return void
     * @throws SignatureBookNoConfigFoundProblem
     * @throws GroupExternalIdNotFoundProblem
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     * @throws UserExternalIdNotFoundProblem
     */
    public function testThrowsProblemWhenAddUserToGroupFails(): void
    {
        $groupExternalId['internalParapheur'] = 5;
        $userExternalId['internalParapheur'] = 15;

        $group = (new Group())->setExternalId($groupExternalId);
        $user = (new User())->setExternalId($userExternalId);

        $this->signatureBookUserServiceMock->addUserToGroup =
            ['errors' => 'Error occurred during the adding user to the group.'];

        $this->expectException(AddUserToAGroupInSignatoryBookFailedProblem::class);

        $this->addUserToAGroupInSignatoryBook->addUserToGroup($user, $group);
    }
}
