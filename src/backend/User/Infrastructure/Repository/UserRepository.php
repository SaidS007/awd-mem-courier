<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief User Repository Repository
 * @author dev@maarch.org
 */

namespace MaarchCourrier\User\Infrastructure\Repository;

use Exception;
use MaarchCourrier\Core\Domain\User\Port\UserInterface;
use MaarchCourrier\Core\Domain\User\Port\UserRepositoryInterface;
use MaarchCourrier\Group\Domain\Group;
use MaarchCourrier\User\Domain\User;
use User\models\UserModel;

class UserRepository implements UserRepositoryInterface
{
    /**
     * @param int $userId
     *
     * @return ?User
     * @throws Exception
     */
    public function getUserById(int $userId): ?User
    {
        if ($userId <= 0) {
            return null;
        }

        $user = UserModel::getById([
            'id'     => $userId,
            'select' => ['id', 'user_id', 'firstName', 'lastName', 'mail', 'phone', 'external_id']
        ]);

        if (empty($user)) {
            return null;
        }

        return User::createFromArray($user);
    }

    /**
     * @return User[]
     * @throws Exception
     */
    public function getUsersWithoutLink(): array
    {
        $users = [];

        $usersDB = UserModel::get([
            'select' => ['*'],
            'where'  => ["external_id->>'internalParapheur' IS NULL"]
        ]);
        foreach ($usersDB as $user) {
            $user['login'] = $user['user_id'];
            $users[] = User::createFromArray($user);
        }

        return $users;
    }

    /**
     * @param  UserInterface  $user
     * @param  array  $values
     * @return void
     * @throws Exception
     */
    public function updateUser(UserInterface $user, array $values): void
    {
        UserModel::update([
            'set'   => $values,
            'where' => ['id = ?'],
            'data'  => [$user->getId()]
        ]);
    }


    /**
     * @param  UserInterface  $user
     * @return Group[]
     * @throws Exception
     */
    public function getGroupsById(UserInterface $user): array
    {
        $groups = [];
        $groupsDB = UserModel::getGroupsById(['id' => $user->getId()]);

        foreach ($groupsDB as $group) {
            $groups[] = (new Group())
                ->setGroupId($group['id'])
                ->setLabel($group['group_id'])
                ->setExternalId(json_decode($group['external_id'], true));
        }

        return $groups;
    }
}
