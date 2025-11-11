<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Group Repository Mock class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\Group\Mock;

use MaarchCourrier\Core\Domain\Group\Port\GroupInterface;
use MaarchCourrier\Core\Domain\Group\Port\GroupRepositoryInterface;
use MaarchCourrier\Group\Domain\Group;

class GroupRepositoryMock implements GroupRepositoryInterface
{
    public array $groupInformations = [
        'group_id'  => 'TEST',
        'group_desc'=> 'Groupe de test',
        'external_id'=> '',
    ];
    public bool $groupUpdated = false;
    public bool $doesGroupExist = true;

    public function getById(int $id): GroupInterface|null
    {
        if (!$this->doesGroupExist) {
            return null;
        }
        return (new Group())
            ->setId($id)
            ->setGroupId('test-group-id')
            ->setLabel('Test Group');
    }

    public function getGroupsWithoutLink(): array
    {
        $externalId = json_decode($this->groupInformations['external_id'], true);
        if (!empty($externalId['internalParapheur'])) {
            return [];
        }

        $group = (new Group())
            ->setGroupId($this->groupInformations['group_id'])
            ->setLabel($this->groupInformations['group_desc'])
            ->setExternalId($externalId);
        return [$group];
    }

    public function updateGroup(GroupInterface $group, array $values): void
    {
        $this->groupUpdated = true;
    }

    public function removeSignatureBookLink(GroupInterface $group): void
    {
        // TODO: Implement removeSignatureBookLink() method.
    }
}
