<?php

declare(strict_types=1);

namespace MaarchCourrier\Tests\Unit\MainResource\Mock;

use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceRepositoryInterface;
use MaarchCourrier\MainResource\Domain\MainResource;

class MainResourceRepositoryMock implements MainResourceRepositoryInterface
{
    public ?MainResource $mainResource = null;
    public bool $isResourceSigned = false;
    public bool $isSignatureBookLinkRemoved = false;
    public bool $doesExistOnView = true;

    public function doesExistOnView(MainResourceInterface $mainResource, string $basketClause): bool {
        return $this->doesExistOnView;
    }

    public function getMainResourceByResId(int $resId): ?MainResourceInterface
    {
        return $this->mainResource;
    }

    public function isMainResourceSigned(MainResourceInterface $mainResource): bool
    {
        return $this->isResourceSigned;
    }

    public function removeSignatureBookLink(MainResourceInterface $mainResource): void
    {
        $this->isSignatureBookLinkRemoved = true;
    }
}
