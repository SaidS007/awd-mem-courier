<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Group Repository class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Group\Infrastructure\Repository;

use Exception;
use Group\models\GroupModel;
use MaarchCourrier\Core\Domain\Group\Port\GroupInterface;
use MaarchCourrier\Core\Domain\Group\Port\GroupRepositoryInterface;
use MaarchCourrier\Group\Domain\Group;

class GroupRepository implements GroupRepositoryInterface
{
    /**
     * @param int $id
     *
     * @return GroupInterface|null
     * @throws Exception
     */
    public function getById(int $id): GroupInterface|null
    {
        $group = GroupModel::get([
            'select' => ['*'],
            'where' => ['id = ?'],
            'data' => [$id]
        ]);

        if (empty($group)) {
            return null;
        }

        $externalId = json_decode($group[0]['external_id'], true);

        return (new Group())
            ->setId($group[0]['id'])
            ->setGroupId($group[0]['group_id'])
            ->setExternalId($externalId);
    }

    /**
     * @return array
     * @throws Exception
     */
    public function getGroupsWithoutLink(): array
    {
        $groups = [];

        $groupsDB = GroupModel::get([
            'select' => ['group_id', 'external_id', 'group_desc'],
            'where'  => ["external_id->>'internalParapheur' IS NULL"]
        ]);

        foreach ($groupsDB as $group) {
            $groups[] = (new Group())
                ->setGroupId($group['group_id'])
                ->setLabel($group['group_desc'])
                ->setExternalId(null);
        }
        return $groups;
    }

    /**
     * @param  GroupInterface  $group
     * @param  array  $values
     * @return void
     * @throws Exception
     */
    public function updateGroup(GroupInterface $group, array $values): void
    {
        GroupModel::update([
            'set'   => $values,
            'where' => ['group_id = ?'],
            'data'  => [$group->getGroupId()]
        ]);
    }

    /**
     * @param  GroupInterface  $group
     * @return void
     * @throws Exception
     */
    public function removeSignatureBookLink(GroupInterface $group): void
    {
        GroupModel::update([
            'postSet' => ['external_id' => "external_id - 'internalParapheur'"],
            'where'   => ['group_id = ?'],
            'data'    => [$group->getGroupId()]
        ]);
    }
}
