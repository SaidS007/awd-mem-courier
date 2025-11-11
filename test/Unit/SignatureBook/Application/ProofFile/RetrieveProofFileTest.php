<?php

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application\ProofFile;

use MaarchCourrier\Authorization\Domain\Problem\PrivilegeForbiddenProblem;
use MaarchCourrier\Core\Domain\MainResource\Problem\ResourceDoesNotExistProblem;
use MaarchCourrier\SignatureBook\Application\ProofFile\RetrieveProofFile;
use MaarchCourrier\SignatureBook\Domain\Problem\DocumentIsNotSignedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\ExternalIdNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\Tests\Unit\Authorization\Mock\PrivilegeCheckerMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\MaarchParapheurProofServiceMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Config\SignatureServiceConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\CurrentUserInformationsMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Webhook\ResourceToSignRepositoryMock;

use PHPUnit\Framework\TestCase;

class RetrieveProofFileTest extends TestCase
{
    private CurrentUserInformationsMock $currentUserInformationsMock;
    private MaarchParapheurProofServiceMock $maarchParapheurProofServiceMock;
    private ResourceToSignRepositoryMock $resourceToSignRepositoryMock;
    private SignatureServiceConfigLoaderMock $signatureBookConfigRepositoryMock;
    private PrivilegeCheckerMock $privilegeCheckerMock;
    private RetrieveProofFile $retrieveProofFile;

    private int $resId = 100;

    protected function setUp(): void
    {
        $this->currentUserInformationsMock = new CurrentUserInformationsMock();
        $this->signatureBookConfigRepositoryMock = new SignatureServiceConfigLoaderMock();
        $this->resourceToSignRepositoryMock = new ResourceToSignRepositoryMock();
        $this->maarchParapheurProofServiceMock = new MaarchParapheurProofServiceMock();
        $this->privilegeCheckerMock = new PrivilegeCheckerMock();

        $this->retrieveProofFile = new RetrieveProofFile(
            $this->currentUserInformationsMock,
            $this->privilegeCheckerMock,
            $this->maarchParapheurProofServiceMock,
            $this->resourceToSignRepositoryMock,
            $this->signatureBookConfigRepositoryMock,
        );

        $this->privilegeCheckerMock->hasPrivilege = true;
        $this->resourceToSignRepositoryMock->resourceNotExists = false;
        $this->resourceToSignRepositoryMock->attachmentNotExists = false;
        $this->resourceToSignRepositoryMock->resourceAlreadySigned = true;
    }

    /**
     * @return void
     * @throws DocumentIsNotSignedProblem
     * @throws ExternalIdNotFoundProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     */
    public function testCannotGetProofFileIfPrivilegeIsForbidden(): void
    {
        $this->privilegeCheckerMock->hasPrivilege = false;
        $this->expectException(PrivilegeForbiddenProblem::class);
        $this->retrieveProofFile->execute($this->resId, false);
    }

    public function testCannotGetProofFileIfExternalIdNotFound(): void
    {
        $this->resourceToSignRepositoryMock->resourceInformations['external_id'] = null;
        $this->expectException(ExternalIdNotFoundProblem::class);
        $this->retrieveProofFile->execute($this->resId, false);
    }

    /**
     * @return void
     * @throws DocumentIsNotSignedProblem
     * @throws ExternalIdNotFoundProblem
     * @throws ResourceDoesNotExistProblem
     * @throws SignatureBookNoConfigFoundProblem
     */
    public function testCannotGetProofFileIfConfigNotFound(): void
    {
        $this->signatureBookConfigRepositoryMock->isFileLoaded = false;
        $this->resourceToSignRepositoryMock->resourceInformations['external_id'] = '{"internalParapheur":20}';

        $this->expectException(SignatureBookNoConfigFoundProblem::class);
        $this->retrieveProofFile->execute($this->resId, false);
    }

    /**
     * @return void
     * @throws ResourceDoesNotExistProblem
     * @throws DocumentIsNotSignedProblem
     * @throws ExternalIdNotFoundProblem
     * @throws SignatureBookNoConfigFoundProblem
     */
    public function testCanGetProofFileForSignedResource(): void
    {
        $this->resourceToSignRepositoryMock->resourceInformations['external_id'] = '{"internalParapheur":20}';
        $proofFile = $this->retrieveProofFile->execute($this->resId, false);
        $this->assertSame(
            $proofFile['encodedProofDocument'],
            $this->maarchParapheurProofServiceMock->returnFromParapheur['encodedProofDocument']
        );
        $this->assertSame(
            $proofFile['format'],
            $this->maarchParapheurProofServiceMock->returnFromParapheur['format']
        );
    }

    public function testCanGetProofFileForSignedAttachment(): void
    {
        $proofFile = $this->retrieveProofFile->execute($this->resId, true);
        $this->assertSame(
            $proofFile['encodedProofDocument'],
            $this->maarchParapheurProofServiceMock->returnFromParapheur['encodedProofDocument']
        );
        $this->assertSame(
            $proofFile['format'],
            $this->maarchParapheurProofServiceMock->returnFromParapheur['format']
        );
    }

    public function testCannotGetProofFileForInexistentResource(): void
    {
        $this->resourceToSignRepositoryMock->resourceNotExists = true;
        $this->expectException(ResourceDoesNotExistProblem::class);
        $proofFile = $this->retrieveProofFile->execute($this->resId, false);
    }

    public function testCannotGetProofFileForInexistentAttachment(): void
    {
        $this->resourceToSignRepositoryMock->attachmentNotExists = true;
        $this->expectException(ResourceDoesNotExistProblem::class);
        $proofFile = $this->retrieveProofFile->execute($this->resId, true);
    }

    public function testCannotGetProofFileForUnsignedResource(): void
    {
        $this->resourceToSignRepositoryMock->resourceAlreadySigned = false;
        $this->expectException(DocumentIsNotSignedProblem::class);
        $proofFile = $this->retrieveProofFile->execute($this->resId, false);
    }

    public function testCannotGetProofFileForUnsignedAttachment(): void
    {
        $this->resourceToSignRepositoryMock->resourceAlreadySigned = false;
        $this->expectException(DocumentIsNotSignedProblem::class);
        $proofFile = $this->retrieveProofFile->execute($this->resId, true);
    }

    public function testCannotGetProofFileIfMaarchParapheurExternalIdIsNotSet(): void
    {
        $this->resourceToSignRepositoryMock->resourceInformations['external_id'] = '{}';
        $this->expectException(ExternalIdNotFoundProblem::class);
        $proofFile = $this->retrieveProofFile->execute($this->resId, false);
    }
}