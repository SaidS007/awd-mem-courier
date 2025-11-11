<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief   StoreSignedResource test
 * @author  dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application\Webhook;

use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\Attachment\Domain\AttachmentType;
use MaarchCourrier\DocumentStorage\Domain\Document;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Application\Webhook\StoreSignedResource;
use MaarchCourrier\SignatureBook\Domain\Problem\StoreResourceProblem;
use MaarchCourrier\SignatureBook\Domain\SignedResource;
use MaarchCourrier\Tests\Unit\Attachment\Mock\AttachmentRepositoryMock;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Repository\VisaWorkflowRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Webhook\ResourceToSignRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Webhook\StoreSignedResourceServiceMock;
use MaarchCourrier\User\Domain\User;
use PHPUnit\Framework\TestCase;

class StoreSignedResourceTest extends TestCase
{
    private ResourceToSignRepositoryMock $resourceToSignRepositoryMock;
    private AttachmentRepositoryMock $attachmentRepositoryMock;
    private MainResourceRepositoryMock $mainResourceRepositoryMock;
    private VisaWorkflowRepositoryMock $visaWorkflowRepositoryMock;
    private StoreSignedResourceServiceMock $storeSignedResourceServiceMock;
    private StoreSignedResource $storeSignedResource;
    private array $returnFromCurlRequestParapheur = [];
    private User $user;
    private SignedResource $signedResource;

    protected function setUp(): void
    {
        $this->resourceToSignRepositoryMock = new ResourceToSignRepositoryMock();
        $this->storeSignedResourceServiceMock = new StoreSignedResourceServiceMock();
        $this->attachmentRepositoryMock = new AttachmentRepositoryMock();
        $this->mainResourceRepositoryMock = new MainResourceRepositoryMock();
        $this->visaWorkflowRepositoryMock = new VisaWorkflowRepositoryMock();

        $this->storeSignedResource = new StoreSignedResource(
            $this->resourceToSignRepositoryMock,
            $this->storeSignedResourceServiceMock,
            $this->attachmentRepositoryMock,
            $this->mainResourceRepositoryMock,
            $this->visaWorkflowRepositoryMock
        );

        $this->returnFromCurlRequestParapheur = [
            'encodedDocument' => 'ContenuDunNouveauFichier',
            'mimetype'        => "application/pdf",
            'filename'        => "PDF_signature.pdf"
        ];

        $this->resourceToSignRepositoryMock->resourceInformations = [
            'version'      => 1,
            'external_id'  => '{}',
            'format'       => 'docx',
            'docserver_id' => 'FASTHD_MAN',
            'path'         => '2024/06/001',
            'filename'     => 'toto.docx',
            'fingerprint'  => '123456azerty',
            'filesize'     => '123456',
        ];

        $this->user = new User();
        $this->user->setId(1);

        $document = (new Document())
            ->setFileName('the-file.pdf')
            ->setFileExtension('pdf');

        $this->mainResourceRepositoryMock->mainResource = (new MainResource())
            ->setResId(100)
            ->setSubject('Courrier Test')
            ->setTypist($this->user)
            ->setChrono('MAARCH/2024/1')
            ->setDocument($document);

        $this->attachmentRepositoryMock->attachment = $this->makeAttachment($document);

        $externalState = ["hasStampSignature" => false, "hasDigitalSignature" => true];

        $this->signedResource = new SignedResource();
        $this->signedResource->setResIdSigned(100);
        $this->signedResource->setExternalState($externalState);
        $this->signedResource->setStatus("VAL");
        $this->signedResource->setEncodedContent($this->returnFromCurlRequestParapheur['encodedDocument']);
    }

    private function makeAttachment(Document $document) : Attachment
    {
        $signableAttachmentType = (new AttachmentType())
            ->setType('response_project')
            ->setLabel('Projet de réponse')
            ->setSignable(true);

        return (new Attachment())
            ->setChrono('MAARCH/2024D/1000')
            ->setTitle('PDF_Reponse_blocsignature')
            ->setTypist($this->user)
            ->setRecipientId(6)
            ->setRecipientType('contact')
            ->setRelation(1)
            ->setExternalDocumentId(20)
            ->setType($signableAttachmentType);
    }

    /**
     * @throws StoreResourceProblem
     */
    public function testCanCreateIntermediateSignedVersionOfResource(): void
    {
        $this->visaWorkflowRepositoryMock->lastStepVisa = false;

        $this->signedResource->setResIdMaster(null);

        $newId = $this->storeSignedResource->store($this->signedResource);
        $this->assertSame($newId, $this->signedResource->getResIdSigned());
        $this->assertSame(
            $this->resourceToSignRepositoryMock->resourceInformations['version'] + 1,
            $this->resourceToSignRepositoryMock->numNewVersionResource
        );
        $this->assertFalse($this->resourceToSignRepositoryMock->signedVersionCreate);
    }

    public function testCanCreateFinalSignedVersionOrResource(): void
    {
        $this->visaWorkflowRepositoryMock->lastStepVisa = true;

        $this->signedResource->setResIdMaster(null);

        $newId = $this->storeSignedResource->store($this->signedResource);
        $this->assertSame($newId, $this->signedResource->getResIdSigned());
        $this->assertSame(1, $this->resourceToSignRepositoryMock->numNewVersionResource);
        $this->assertTrue($this->resourceToSignRepositoryMock->signedVersionCreate);
    }

    /**
     * @throws StoreResourceProblem
     */
    public function testCanCreateIntermediateSignedVersionOfAttachmentWithCertificateOnly(): void
    {
        $this->visaWorkflowRepositoryMock->lastStepVisa = false;
        $currentVersion = $this->attachmentRepositoryMock->attachment->getRelation();

        $this->storeSignedResourceServiceMock->resIdNewSignedDoc = 1;

        $this->signedResource->setResIdMaster(10);

        $this->storeSignedResource->store($this->signedResource);
        $this->assertTrue($this->attachmentRepositoryMock->resourceUpdated);
        $this->assertSame('OBS', $this->attachmentRepositoryMock->attachment->getStatus());
        $this->assertSame($currentVersion + 1, $this->attachmentRepositoryMock->attachment->getRelation());
    }

    /**
     * @return void
     * @throws StoreResourceProblem
     */
    public function testCanCreateFinalSignedVersionOfAttachment(): void
    {
        $this->visaWorkflowRepositoryMock->lastStepVisa = true;

        $this->signedResource->setResIdMaster(10);

        $newId = $this->storeSignedResource->store($this->signedResource);
        $this->assertSame($newId, $this->storeSignedResourceServiceMock->resIdNewSignedDoc);
        $this->assertTrue($this->attachmentRepositoryMock->resourceUpdated);
        $this->assertSame('SIGN', $this->attachmentRepositoryMock->attachment->getStatus());
    }


    /**
     * @return void
     * @throws StoreResourceProblem
     */
    public function testCannotStoreSignedVersionOfResourceIfStorageFunctionError(): void
    {
        $this->storeSignedResourceServiceMock->errorStorage = true;

        $this->signedResource->setResIdMaster(null);

        $this->expectException(StoreResourceProblem::class);
        $newId = $this->storeSignedResource->store($this->signedResource);
    }
}
