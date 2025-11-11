<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief Main Resource Class
 * @author dev@maarch.org
 */

declare(strict_types=1);

namespace MaarchCourrier\MainResource\Domain;

use DateTimeImmutable;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceInterface;
use MaarchCourrier\Core\Domain\SignatureBook\Port\HasSignatureInterface;
use MaarchCourrier\Core\Domain\User\Port\UserInterface;
use MaarchCourrier\DocumentStorage\Domain\Document;

class MainResource implements MainResourceInterface, HasSignatureInterface
{
    private int $resId;
    private ?string $subject;
    private UserInterface $typist;
    private ?string $chrono;
    private Integration $integration;
    private Document $document;
    private ?int $externalDocumentId = null;
    private array $externalState = [];
    private int $version = 1;
    private DateTimeImmutable $creationDate;
    private DateTimeImmutable $modificationDate;

    /**
     * @return int
     */
    public function getResId(): int
    {
        return $this->resId;
    }

    /**
     * @param int $resId
     * @return $this
     */
    public function setResId(int $resId): MainResource
    {
        $this->resId = $resId;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getSubject(): ?string
    {
        return $this->subject;
    }

    /**
     * @param string|null $subject
     * @return $this
     */
    public function setSubject(?string $subject): MainResource
    {
        $this->subject = $subject;
        return $this;
    }

    /**
     * @return UserInterface
     */
    public function getTypist(): UserInterface
    {
        return $this->typist;
    }

    /**
     * @param UserInterface $typist
     * @return $this
     */
    public function setTypist(UserInterface $typist): MainResource
    {
        $this->typist = $typist;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getChrono(): ?string
    {
        return $this->chrono;
    }

    /**
     * @param string|null $chrono
     * @return $this
     */
    public function setChrono(?string $chrono): MainResource
    {
        $this->chrono = $chrono;
        return $this;
    }

    /**
     * @return Integration
     */
    public function getIntegration(): Integration
    {
        return $this->integration;
    }

    /**
     * @param Integration $integration
     * @return $this
     */
    public function setIntegration(Integration $integration): MainResource
    {
        $this->integration = $integration;
        return $this;
    }

    /**
     * @return Document
     */
    public function getDocument(): Document
    {
        return $this->document;
    }

    /**
     * @param Document $document
     * @return $this
     */
    public function setDocument(Document $document): MainResource
    {
        $this->document = $document;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getFilename(): ?string
    {
        return $this->document->getFileName();
    }

    /**
     * @return string|null
     */
    public function getFileFormat(): ?string
    {
        return $this->document->getFileExtension();
    }

    /**
     * @return bool|null
     */
    public function isInSignatureBook(): ?bool
    {
        return $this->integration->getInSignatureBook();
    }

    /**
     * @return int|null
     */
    public function getExternalDocumentId(): ?int
    {
        return $this->externalDocumentId;
    }

    /**
     * @param int|null $externalDocumentId
     * @return $this
     */
    public function setExternalDocumentId(?int $externalDocumentId): MainResource
    {
        $this->externalDocumentId = $externalDocumentId;
        return $this;
    }

    public function getExternalState(): array
    {
        return $this->externalState;
    }

    public function setExternalState(array $externalState): MainResource
    {
        $this->externalState = $externalState;
        return $this;
    }

    /**
     * @return int
     */
    public function getVersion(): int
    {
        return $this->version;
    }

    /**
     * @param int $version
     *
     * @return MainResourceInterface
     */
    public function setVersion(int $version): MainResourceInterface
    {
        $this->version = $version;
        return $this;
    }

    /**
     * @return DateTimeImmutable
     */
    public function getCreationDate(): DateTimeImmutable
    {
        return $this->creationDate;
    }

    /**
     * @param DateTimeImmutable $date
     *
     * @return MainResourceInterface
     */
    public function setCreationDate(DateTimeImmutable $date): MainResourceInterface
    {
        $this->creationDate = $date;
        return $this;
    }

    /**
     * @return DateTimeImmutable
     */
    public function getModificationDate(): DateTimeImmutable
    {
        return $this->modificationDate;
    }

    /**
     * @param DateTimeImmutable $date
     *
     * @return MainResourceInterface
     */
    public function setModificationDate(DateTimeImmutable $date): MainResourceInterface
    {
        $this->modificationDate = $date;
        return $this;
    }

    public function getHasStampSignature(): ?bool
    {
        return $this->externalState['hasStampSignature'] ?? false;
    }

    public function getHasDigitalSignature(): ?bool
    {
        return $this->externalState['hasDigitalSignature'] ?? false;
    }
}
