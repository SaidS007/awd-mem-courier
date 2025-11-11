<?php

declare(strict_types=1);

namespace MaarchCourrier\Tests\Unit\SignatureBook\Mock\Repository;

use MaarchCourrier\Core\Domain\DiffusionList\Port\ListInstanceInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceInterface;
use MaarchCourrier\Core\Domain\User\Port\UserInterface;
use MaarchCourrier\SignatureBook\Domain\ListInstance;
use MaarchCourrier\SignatureBook\Domain\Port\VisaWorkflowRepositoryInterface;
use MaarchCourrier\User\Domain\User;

class VisaWorkflowRepositoryMock implements VisaWorkflowRepositoryInterface
{
    public bool $isActiveWorkflow = false;
    public bool $doesCurrentStepUserExist = true;
    public bool $lastStepVisa = false;
    public bool $listinstanceUpdated = false;
    public ?ListInstance $listInstance = null;
    /**
     * @var ListInstance[]
     */
    public array $activeWorkflow = [];
    public bool $isInWorkflow = true;
    public bool $hasWorkflow = true;
    public bool $hasWorkflowResetForMainResource = false;

    public function isWorkflowActiveByMainResource(MainResourceInterface $mainResource): bool
    {
        return $this->isActiveWorkflow;
    }

    public function getCurrentStepUserByMainResource(MainResourceInterface $mainResource): ?UserInterface
    {
        if (!$this->doesCurrentStepUserExist) {
            return null;
        }
        return User::createFromArray(['id' => $mainResource->getTypist()->getId()]);
    }

    public function isLastStepWorkflowByMainResource(MainResourceInterface $mainResource): bool
    {
        return $this->lastStepVisa;
    }

    public function getCurrentStepByMainResource(MainResourceInterface $mainResource): ?ListInstanceInterface
    {
        return $this->listInstance;
    }

    public function updateListInstance(ListInstanceInterface $listInstance, array $values): void
    {
        $this->listinstanceUpdated = true;
    }

    public function getActiveVisaWorkflowByMainResource(MainResourceInterface $mainResource): array
    {
        return $this->activeWorkflow;
    }

    public function isInWorkflow(MainResourceInterface $mainResource): bool
    {
        return $this->isInWorkflow;
    }

    public function hasWorkflow(MainResourceInterface $mainResource): bool
    {
        return $this->hasWorkflow;
    }

    public function restWorkflowByMainResource(MainResourceInterface $mainResource): void
    {
        $this->hasWorkflowResetForMainResource = true;
    }
}
