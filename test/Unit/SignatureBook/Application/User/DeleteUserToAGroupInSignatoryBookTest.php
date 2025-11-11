<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Delete User To A Group In Signatory Book Test
 */

namespace Unit\SignatureBook\Application\User;

use MaarchCourrier\Group\Domain\Group;
use MaarchCourrier\SignatureBook\Application\User\DeleteUserToAGroupInSignatoryBook;
use MaarchCourrier\SignatureBook\Domain\Problem\DeleteUserToAGroupInSignatoryBookFailedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\GroupExternalIdNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\UserExternalIdNotFoundProblem;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\SignatureServiceJsonConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\User\MaarchParapheurUserServiceMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class DeleteUserToAGroupInSignatoryBookTest extends TestCase
{
    private MaarchParapheurUserServiceMock $signatureBookUserServiceMock;
    private SignatureServiceJsonConfigLoaderMock $signatureServiceJsonConfigLoaderMock;
    private DeleteUserToAGroupInSignatoryBook $deleteUserToAGroupInSignatoryBook;

    protected function setUp(): void
    {
        $this->signatureBookUserServiceMock = new MaarchParapheurUserServiceMock();
        $this->signatureServiceJsonConfigLoaderMock = new SignatureServiceJsonConfigLoaderMock();
        $this->deleteUserToAGroupInSignatoryBook = new DeleteUserToAGroupInSignatoryBook(
            $this->signatureBookUserServiceMock,
            $this->signatureServiceJsonConfigLoaderMock
        );
    }

    /**
     * @return void
     * @throws SignatureBookNoConfigFoundProblem
     * @throws GroupExternalIdNotFoundProblem
     * @throws DeleteUserToAGroupInSignatoryBookFailedProblem
     * @throws UserExternalIdNotFoundProblem
     */
    public function testThrowsProblemWhenSignatureBookConfigNotFound(): void
    {
        $this->signatureServiceJsonConfigLoaderMock->signatureServiceConfigLoader
            = null;

        $group = new Group();
        $user = new User();

        $this->expectException(SignatureBookNoConfigFoundProblem::class);

        $this->deleteUserToAGroupInSignatoryBook->deleteUserToAGroup(
            $user,
            $group
        );
    }

    /**
     * @return void
     * @throws DeleteUserToAGroupInSignatoryBookFailedProblem
     * @throws GroupExternalIdNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserExternalIdNotFoundProblem
     */
    public function testThrowsProblemWhenGroupExternalIdNotFound(): void
    {
        $user = new User();
        $group = (new Group())->setExternalId([]);

        $this->expectException(GroupExternalIdNotFoundProblem::class);

        $this->deleteUserToAGroupInSignatoryBook->deleteUserToAGroup(
            $user,
            $group
        );
    }

    /**
     * @throws GroupExternalIdNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws DeleteUserToAGroupInSignatoryBookFailedProblem
     */
    public function testThrowsProblemWhenUserExternalIdNotFound(): void
    {
        $groupExternalId['internalParapheur'] = 5;
        $user = new User();
        $group = (new Group())->setExternalId($groupExternalId);

        $this->expectException(UserExternalIdNotFoundProblem::class);

        $this->deleteUserToAGroupInSignatoryBook->deleteUserToAGroup(
            $user,
            $group
        );
    }

    /**
     * @return void
     * @throws DeleteUserToAGroupInSignatoryBookFailedProblem
     * @throws GroupExternalIdNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserExternalIdNotFoundProblem
     */
    public function testThrowsProblemWhenDeleteUserToGroupFails(): void
    {
        $groupExternalId['internalParapheur'] = 5;
        $userExternalId['internalParapheur'] = 15;

        $group = (new Group())->setExternalId($groupExternalId);
        $user = (new User())->setExternalId($userExternalId);

        $this->signatureBookUserServiceMock->deleteUserToGroup =
            ['errors' => 'An error occurred when deleting the user to the group.'];

        $this->expectException(DeleteUserToAGroupInSignatoryBookFailedProblem::class);

        $this->deleteUserToAGroupInSignatoryBook->deleteUserToAGroup($user, $group);
    }

    /**
     * @return void
     * @throws DeleteUserToAGroupInSignatoryBookFailedProblem
     * @throws GroupExternalIdNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserExternalIdNotFoundProblem
     */
    public function testDeletesUserToGroupSuccessfully(): void
    {
        $groupExternalId['internalParapheur'] = 5;
        $userExternalId['internalParapheur'] = 15;

        $group = (new Group())->setExternalId($groupExternalId);
        $user = (new User())->setExternalId($userExternalId);

        $this->signatureBookUserServiceMock->deleteUserToGroup = true;

        $this->deleteUserToAGroupInSignatoryBook->deleteUserToAGroup($user, $group);

        $this->assertTrue($this->signatureBookUserServiceMock->deleteUserToGroupCalled);
    }
}
