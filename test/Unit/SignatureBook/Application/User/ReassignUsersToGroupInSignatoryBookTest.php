<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Reassign Users To Group In Signatory Book Test
 * @author dev@maarch.org
 */

namespace Unit\SignatureBook\Application\User;

use MaarchCourrier\Group\Domain\Group;
use MaarchCourrier\SignatureBook\Application\Group\ReassignUsersToGroupInSignatoryBook;
use MaarchCourrier\SignatureBook\Domain\Problem\AddUserToAGroupInSignatoryBookFailedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\GroupExternalIdNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\UserExternalIdNotFoundProblem;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\SignatureServiceJsonConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\User\MaarchParapheurUserServiceMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class ReassignUsersToGroupInSignatoryBookTest extends TestCase
{
    private MaarchParapheurUserServiceMock $signatureBookUserServiceMock;
    private SignatureServiceJsonConfigLoaderMock $signatureServiceJsonConfigLoaderMock;
    private ReassignUsersToGroupInSignatoryBook $reassignUsersToGroupInSignatoryBook;

    protected function setUp(): void
    {
        $this->signatureBookUserServiceMock = new MaarchParapheurUserServiceMock();
        $this->signatureServiceJsonConfigLoaderMock = new SignatureServiceJsonConfigLoaderMock();
        $this->reassignUsersToGroupInSignatoryBook = new ReassignUsersToGroupInSignatoryBook(
            $this->signatureBookUserServiceMock,
            $this->signatureServiceJsonConfigLoaderMock
        );
    }

    /**
     * @throws GroupExternalIdNotFoundProblem
     * @throws UserExternalIdNotFoundProblem
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     */
    public function testCannotReassignUsersWhenSignatureBookConfigNotFound(): void
    {
        $this->signatureServiceJsonConfigLoaderMock->signatureServiceConfigLoader = null;

        $group = new Group();
        $user = new User();

        $this->expectException(SignatureBookNoConfigFoundProblem::class);

        $this->reassignUsersToGroupInSignatoryBook->reassignUsers($group, [$user]);
    }

    /**
     * @throws SignatureBookNoConfigFoundProblem
     * @throws UserExternalIdNotFoundProblem
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     */
    public function testCannotReassignUsersWhenGroupExternalIdNotFound(): void
    {
        $group = (new Group())->setExternalId([]);
        $user = new User();

        $this->expectException(GroupExternalIdNotFoundProblem::class);

        $this->reassignUsersToGroupInSignatoryBook->reassignUsers($group, [$user]);
    }

    /**
     * @throws GroupExternalIdNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     */
    public function testCannotReassignUsersWhenUserExternalIdNotFound(): void
    {
        $groupExternalId = ['internalParapheur' => 5];
        $group = (new Group())->setExternalId($groupExternalId);
        $user = (new User())->setExternalId([]);

        $this->expectException(UserExternalIdNotFoundProblem::class);

        $this->reassignUsersToGroupInSignatoryBook->reassignUsers($group, [$user]);
    }

    /**
     * @throws SignatureBookNoConfigFoundProblem
     * @throws GroupExternalIdNotFoundProblem
     * @throws UserExternalIdNotFoundProblem
     */
    public function testCannotReassignUsersWhenAddUserToGroupFails(): void
    {
        $groupExternalId = ['internalParapheur' => 5];
        $group = (new Group())->setExternalId($groupExternalId);
        $userExternalId = ['internalParapheur' => 15];
        $userId = 10;
        $user = (new User())
            ->setId($userId)
            ->setExternalId($userExternalId);

        $this->signatureBookUserServiceMock->addUserToGroup = [
                'errors' => 'An error occurred when adding the user to the group.'
            ];

        $this->expectException(AddUserToAGroupInSignatoryBookFailedProblem::class);

        $this->reassignUsersToGroupInSignatoryBook->reassignUsers($group, [$user]);
    }

    /**
     * @throws GroupExternalIdNotFoundProblem
     * @throws UserExternalIdNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     * @throws AddUserToAGroupInSignatoryBookFailedProblem
     */
    public function testReassignUserToGroupSuccessfully(): void
    {
        $groupExternalId = ['internalParapheur' => 5];
        $group = (new Group())->setExternalId($groupExternalId);
        $userExternalId = ['internalParapheur' => 15];
        $user[] = (new User())->setExternalId($userExternalId);
        $userExternalId = ['internalParapheur' => 14];
        $userId = 10;
        $user[] = (new User())
            ->setId($userId)
            ->setExternalId($userExternalId);


        $this->reassignUsersToGroupInSignatoryBook->reassignUsers($group, $user);

        $this->assertTrue($this->signatureBookUserServiceMock->addUserToGroupIsCalled);
    }
}
