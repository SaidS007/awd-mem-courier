<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Signature Book Workflow Service Mock
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Mock\Workflow;

use MaarchCourrier\SignatureBook\Domain\Port\Workflow\SignatureBookWorkflowServiceInterface;
use MaarchCourrier\SignatureBook\Domain\SignatureBookResource;
use MaarchCourrier\SignatureBook\Domain\SignatureBookServiceConfig;

class SignatureBookWorkflowServiceMock implements SignatureBookWorkflowServiceInterface
{
    public SignatureBookServiceConfig $config;
    public bool $doesWorkflowExist = true;
    public bool $didWorkflowUpdated = true;
    public ?array $workflowsToUpdateInSignatureBook = null;
    public bool $didWorkflowinterrupted = true;
    public bool $didResourceDeleted = true;


    /**
     * @inheritDoc
     */
    public function setConfig(SignatureBookServiceConfig $config): void
    {
        $this->config = $config;
    }

    /**
     * @inheritDoc
     */
    public function doesWorkflowExists(SignatureBookResource $resource): bool|array
    {
        if (!$this->doesWorkflowExist) {
            return [
                'code' => 400,
                'error' => 'error message from api'
            ];
        }
        return true;
    }

    /**
     * @inheritDoc
     */
    public function updateWorkflow(SignatureBookResource $resource, array $workflow): bool|array
    {
        $this->workflowsToUpdateInSignatureBook = $workflow;
        if (!$this->didWorkflowUpdated) {
            return [
                'code' => 400,
                'error' => 'error message from api'
            ];
        }
        return true;
    }

    public function interruptWorkflow(SignatureBookResource $resource): bool|array
    {
        if (!$this->didWorkflowinterrupted) {
            return [
                'code' => 400,
                'error' => 'error message from api'
            ];
        }
        return true;
    }

    public function deleteResource(SignatureBookResource $resource): bool|array
    {
        if (!$this->didResourceDeleted) {
            return [
                'code' => 400,
                'error' => 'error message from api'
            ];
        }
        return true;
    }
}
