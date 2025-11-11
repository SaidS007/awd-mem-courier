<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief   UserRepositoryMock
 * @author  dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Mock;

use MaarchCourrier\Core\Domain\User\Port\UserInterface;
use MaarchCourrier\Core\Domain\User\Port\UserRepositoryInterface;
use MaarchCourrier\Group\Domain\Group;
use MaarchCourrier\User\Domain\User;

class UserRepositoryMock implements UserRepositoryInterface
{
    public bool $doesUserExist = true;
    public bool $doesInternalParapheurExist = false;
    public array $userArray = [];
    public bool $userUpdated = false;

    public array $userGroup = [
        'group_id'    => 'TEST',
        'group_desc'  => 'Groupe de test',
        'external_id' => '{}'
    ];

    /**
     * @param  int  $userId
     * @return User|null
     */
    public function getUserById(int $userId): ?User
    {
        if ($userId <= 0 || !$this->doesUserExist) {
            return null;
        }

        $this->userArray = [
            'id'          => $userId,
            'user_id'     => 'testLogin',
            'firstName'   => 'first',
            'lastName'    => 'last',
            'mail'        => 'test@test.com',
            'phone'       => '0712345678',
            'external_id' => '[]'
        ];

        if ($this->doesInternalParapheurExist) {
            $this->userArray['external_id'] = '{"internalParapheur": 1}';
        }

        return User::createFromArray($this->userArray);
    }

    /**
     * @return User[]
     */
    public function getUsersWithoutLink(): array
    {
        $externalId = json_decode($this->userArray['external_id'], true);
        if (!empty($externalId)) {
            return [];
        }

        $users = [];
        $this->userArray['login'] = $this->userArray['user_id'];
        $users[] = User::createFromArray($this->userArray);
        return $users;
    }

    /**
     * @param  UserInterface  $user
     * @param  array  $values
     * @return void
     */
    public function updateUser(UserInterface $user, array $values): void
    {
        $this->userUpdated = true;
    }

    /**
     * @param  UserInterface  $user
     * @return Group[]
     */
    public function getGroupsById(UserInterface $user): array
    {
        $externalId = json_decode($this->userGroup['external_id'], true);

        $group = (new Group())
            ->setGroupId($this->userGroup['group_id'])
            ->setLabel($this->userGroup['group_desc'])
            ->setExternalId($externalId);

        return [$group];
    }
}
