<?php

declare(strict_types=1);

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application;

use MaarchCourrier\Core\Domain\Problem\NewInternalParapheurDisabledProblem;
use MaarchCourrier\SignatureBook\Application\GetSignatureBookServiceVersion;
use MaarchCourrier\SignatureBook\Domain\Problem\CannotGetServiceVersionProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\SignatureBookServiceVersion;
use MaarchCourrier\SignatureBook\Infrastructure\SignatureServiceVersionDenormalizer;
use MaarchCourrier\Tests\Unit\Core\Mock\EnvironmentMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\MaarchParapheurSignatureServiceMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Config\SignatureServiceConfigLoaderMock;
use PHPUnit\Framework\TestCase;

class GetSignatureBookServiceVersionTest extends TestCase
{
    private EnvironmentMock $environmentMock;

    private SignatureServiceConfigLoaderMock $configLoaderMock;

    private MaarchParapheurSignatureServiceMock $signatureServiceMock;

    private GetSignatureBookServiceVersion $getSignatureBookService;

    protected function setUp(): void
    {
        $this->environmentMock = new EnvironmentMock();
        $this->configLoaderMock = new SignatureServiceConfigLoaderMock();
        $this->signatureServiceMock = new MaarchParapheurSignatureServiceMock();

        $this->getSignatureBookService = new GetSignatureBookServiceVersion(
            $this->environmentMock,
            $this->configLoaderMock,
            $this->signatureServiceMock,
            new SignatureServiceVersionDenormalizer()
        );
    }


    public function testCannotGetVersionWhenNewParapheurIsDisabled(): void
    {
        $this->environmentMock->isNewInternalParapheurEnabled = false;

        $this->expectExceptionObject(new NewInternalParapheurDisabledProblem());

        $this->getSignatureBookService->execute();
    }

    public function testCannotGetVersionWhenConfigIsMissing(): void
    {
        $this->environmentMock->isNewInternalParapheurEnabled = true;
        $this->configLoaderMock->isFileLoaded = false;

        $this->expectExceptionObject(new SignatureBookNoConfigFoundProblem());

        $this->getSignatureBookService->execute();
    }

    public function testCannotGetVersionWhenServiceReturnsAnError(): void
    {
        $this->environmentMock->isNewInternalParapheurEnabled = true;
        $this->signatureServiceMock->version = ['errors' => 'an error !'];

        $this->expectExceptionObject(new CannotGetServiceVersionProblem('an error !'));

        $this->getSignatureBookService->execute();
    }

    public function testCanGetVersionFromService(): void
    {
        $this->environmentMock->isNewInternalParapheurEnabled = true;
        $this->signatureServiceMock->version = [
            'version' => '24.1.2',
            'build'   => '123456',
            'time'    => '2024-08-02 11:00'
        ];

        $expectedResult = new SignatureBookServiceVersion(
            version: '24.1.2',
            build: '123456',
            time: '2024-08-02 11:00'
        );

        $result = $this->getSignatureBookService->execute();

        $this->assertEquals($expectedResult, $result);
    }
}
