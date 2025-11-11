<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Update Workflow In Signature Book Spy
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Spy;

use MaarchCourrier\SignatureBook\Domain\Port\Workflow\UpdateWorkflowInSignatureBookInterface;

class UpdateWorkflowInSignatureBookSpy implements UpdateWorkflowInSignatureBookInterface
{
    public array $passedResourcesWithListInstance = [];

    public function update(array $resourcesWithListInstance, array $resourcesToUpdate = []): void
    {
        $this->passedResourcesWithListInstance = $resourcesWithListInstance;
    }
}
