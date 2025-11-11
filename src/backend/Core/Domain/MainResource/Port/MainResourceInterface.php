<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Main Resource Interface
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Core\Domain\MainResource\Port;

use DateTimeImmutable;
use MaarchCourrier\Core\Domain\User\Port\UserInterface;
use MaarchCourrier\DocumentStorage\Domain\Document;

interface MainResourceInterface
{
    /**
     * @return int
     */
    public function getResId(): int;
    public function setResId(int $resId): self;

    /**
     * @return string|null
     */
    public function getSubject(): ?string;
    public function setSubject(?string $subject): self;

    /**
     * @return UserInterface
     */
    public function getTypist(): UserInterface;
    public function setTypist(UserInterface $typist): self;

    /**
     * @return string|null
     */
    public function getChrono(): ?string;
    public function setChrono(?string $chrono): self;
    public function getDocument(): Document;
    public function setDocument(Document $document): self;
    public function getFilename(): ?string;

    /**
     * @return string|null
     */
    public function getFileFormat(): ?string;

    /**
     * @return bool|null
     */
    public function isInSignatureBook(): ?bool;

    /**
     * @return int|null
     */
    public function getExternalDocumentId(): ?int;

    /**
     * @param int|null $externalDocumentId
     * @return self
     */
    public function setExternalDocumentId(?int $externalDocumentId): self;
    public function getExternalState(): array;
    public function setExternalState(array $externalState): self;
    public function getVersion(): int;
    public function setVersion(int $version): self;
    public function getCreationDate(): DateTimeImmutable;
    public function setCreationDate(DateTimeImmutable $date): self;
    public function getModificationDate(): DateTimeImmutable;
    public function setModificationDate(DateTimeImmutable $date): self;
    public function getHasDigitalSignature(): ?bool;
}
