<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief ContinueCircuitActionTest class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\Tests\Unit\SignatureBook\Application\Action;

use Exception;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Domain\ListInstance;
use MaarchCourrier\SignatureBook\Domain\Mode;
use MaarchCourrier\SignatureBook\Domain\Problem\CurrentTokenIsNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\DataToBeSentToTheParapheurAreEmptyProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\DigitalSignatureIsMandatoryProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\NoDocumentsInSignatureBookForThisId;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureIsMandatoryProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureNotAppliedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\StampSignatureForbiddenProblem;
use MaarchCourrier\Tests\Unit\MainResource\Mock\MainResourceRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\CurrentUserInformationsMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\MaarchParapheurSignatureServiceMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Action\SignatureServiceJsonConfigLoaderMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Mock\Repository\VisaWorkflowRepositoryMock;
use MaarchCourrier\Tests\Unit\SignatureBook\Spy\UpdateWorkflowInSignatureBookSpy;
use PHPUnit\Framework\TestCase;
use MaarchCourrier\SignatureBook\Application\Action\ContinueCircuitAction;

class ContinueCircuitActionTest extends TestCase
{
    private ContinueCircuitAction $continueCircuitAction;

    private CurrentUserInformationsMock $currentUserRepositoryMock;

    private SignatureServiceJsonConfigLoaderMock $configLoaderMock;

    private MaarchParapheurSignatureServiceMock $signatureServiceMock;

    private MainResourceRepositoryMock $mainResourceRepositoryMock;
    private VisaWorkflowRepositoryMock $visaWorkflowRepositoryMock;
    private UpdateWorkflowInSignatureBookSpy $updateWorkflowInSignatureBookSpy;

    private array $dataMainDocument = [
        "resId"                  => 1,
        "documentId"             => 4,
        "certificate"            => 'certificate',
        "signatures"             => [
            'signatures1' => 'signature'
        ],
        "hashSignature"          => "a41584bdd99fbfeabc7b45f6fa89a4fa075b3070d44b869af35cea87a1584caa568f696d0c9dabad2481dfb
            bc016fd3562fa009d1b3f3cb31e76adfe5cd5b6026a30d5c1bf78e0d85250bd3709ac45a48276242abf3840f55f00ccbade965c202b
            e107c2df02622974c795bb07537de9a8df6cf0c9497c08f261e89ee4617bec",
        "signatureContentLength" => 30000,
        "signatureFieldName"     => "Signature",
        "tmpUniqueId"            => 4,
        'cookieSession'          => "PHPSESSID=n9dskdn94ndz23nn"
    ];

    private array $dataAttachment = [
        "resId"                  => 1,
        "isAttachment"           => true,
        "documentId"             => 5,
        "certificate"            => 'certificate',
        "signatures"             => [
            'signatures1' => 'signature'
        ],
        "hashSignature"          => "a41584bdd99fbfeabc7b45f6fa89a4fa075b3070d44b869af35cea87a1584caa568f696d0c9dabad2481dfb
            bc016fd3562fa009d1b3f3cb31e76adfe5cd5b6026a30d5c1bf78e0d85250bd3709ac45a48276242abf3840f55f00ccbade965c202b
            e107c2df02622974c795bb07537de9a8df6cf0c9497c08f261e89ee4617bec",
        "signatureContentLength" => 30000,
        "signatureFieldName"     => "Signature",
        "tmpUniqueId"            => 4,
        'cookieSession'          => "PHPSESSID=n9dskdn94ndz23nn"
    ];

    protected function setUp(): void
    {
        $this->currentUserRepositoryMock = new CurrentUserInformationsMock();
        $this->configLoaderMock = new SignatureServiceJsonConfigLoaderMock();
        $this->signatureServiceMock = new MaarchParapheurSignatureServiceMock();

        $this->mainResourceRepositoryMock = new MainResourceRepositoryMock();
        $this->visaWorkflowRepositoryMock = new VisaWorkflowRepositoryMock();
        $this->updateWorkflowInSignatureBookSpy = new UpdateWorkflowInSignatureBookSpy();

        $this->mainResourceRepositoryMock->mainResource =
            (new MainResource())
                ->setResId(1)
                ->setSubject('Courrier test');

        $this->visaWorkflowRepositoryMock->listInstance =
            (new ListInstance())
                ->setResId(1)
                ->setSequence(1)
                ->setItemId(10)
                ->setItemType('user_id')
                ->setItemMode(Mode::SIGN)
                ->setSignatory(true)
                ->setRequestedSignature(true)
                ->setListInstanceId(1);


        // Ajout du certificat électronique pour le document principal
        $this->dataMainDocument['certificate'] = 'certificate';
        $this->dataMainDocument['hashSignature'] = 'a41584bdd99fbfeabc7b45f6fa89a4fa075b3070d44b869af35cea87a1584caa568f696d0c9dabad2481dfb
            bc016fd3562fa009d1b3f3cb31e76adfe5cd5b6026a30d5c1bf78e0d85250bd3709ac45a48276242abf3840f55f00ccbade965c202b
            e107c2df02622974c795bb07537de9a8df6cf0c9497c08f261e89ee4617bec';

        // Ajout de la griffe pour le document principal
        $this->dataMainDocument['signatures'] = [
            'signatures1' => 'signature'
        ];

        $this->continueCircuitAction = new ContinueCircuitAction(
            $this->currentUserRepositoryMock,
            $this->signatureServiceMock,
            $this->configLoaderMock,
            $this->mainResourceRepositoryMock,
            $this->visaWorkflowRepositoryMock,
            true,
            $this->updateWorkflowInSignatureBookSpy
        );
    }


    /**
     * @return void
     * @throws CurrentTokenIsNotFoundProblem
     * @throws DataToBeSentToTheParapheurAreEmptyProblem
     * @throws NoDocumentsInSignatureBookForThisId
     * @throws SignatureBookNoConfigFoundProblem
     * @throws SignatureNotAppliedProblem
     */
    public function testTheNewInternalParapheurIsEnabled(): void
    {
        $result = $this->continueCircuitAction->execute(
            1,
            ["digitalCertificate" => true, "1" => [$this->dataMainDocument]],
            []
        );
        self::assertTrue($result);
    }

    /**
     * @throws Exception
     */
    public function testCanSignMainDocumentAndAttachmentIfAllDataAreSet(): void
    {
        $result = $this->continueCircuitAction->execute(
            1,
            ["digitalCertificate" => true, "1" => [$this->dataMainDocument, $this->dataAttachment]],
            []
        );
        self::assertTrue($result);
    }

    /**
     * @throws Exception
     */
    public function testCannotSignIfThereIsNotDocumentInDataForSelectedResId(): void
    {
        $this->expectException(NoDocumentsInSignatureBookForThisId::class);
        $this->continueCircuitAction->execute(2, ["1" => [$this->dataMainDocument]], []);
    }

    /**
     * @throws Exception
     */
    public function testCannotSignIfTheSignatureBookConfigIsNotFound(): void
    {
        $this->configLoaderMock->signatureServiceConfigLoader = null;
        $this->expectException(SignatureBookNoConfigFoundProblem::class);
        $this->continueCircuitAction->execute(1, ["1" => [$this->dataMainDocument]], []);
    }

    /**
     * @throws Exception
     */
    public function testCannotSignIfNoTokenIsFound(): void
    {
        $this->currentUserRepositoryMock->token = '';
        $this->expectException(CurrentTokenIsNotFoundProblem::class);
        $this->continueCircuitAction->execute(1, ["1" => [$this->dataMainDocument]], []);
    }

    /**
     * @return void
     * @throws CurrentTokenIsNotFoundProblem
     * @throws DataToBeSentToTheParapheurAreEmptyProblem
     * @throws NoDocumentsInSignatureBookForThisId
     * @throws SignatureBookNoConfigFoundProblem
     * @throws SignatureNotAppliedProblem
     */
    public function testCannotSignIfDuringTheApplicationOfTheSignatureAnErrorOccurred(): void
    {
        $this->signatureServiceMock->applySignature = ['errors' => 'An error has occurred'];
        $this->expectException(SignatureNotAppliedProblem::class);
        $this->continueCircuitAction->execute(1, ["digitalCertificate" => true, "1" => [$this->dataMainDocument]], []);
    }

    /**
     * @throws Exception
     */
    public function testCannotSignIfMandatoryDataIsEmpty(): void
    {
        $dataMainDocument = [
            "documentId"             => 4,
            "certificate"            => 'certificate',
            "signatures"             => [],
            "hashSignature"          => "",
            "signatureContentLength" => 0,
            "signatureFieldName"     => "",
            "tmpUniqueId"            => 4,
            'cookieSession'          => "n9dskdn94ndz23nn"
        ];
        $this->expectException(DataToBeSentToTheParapheurAreEmptyProblem::class);
        $this->expectExceptionObject(
            new DataToBeSentToTheParapheurAreEmptyProblem(
                ['resId', 'hashSignature, signatureContentLength, signatureFieldName']
            )
        );
        $this->continueCircuitAction->execute(1, ["digitalCertificate" => true, "1" => [$dataMainDocument]], []);
    }

    public function testCannotExecuteActionAsSignatoryWithoutStampAndWithoutCertificate(): void
    {
        $this->dataMainDocument['certificate'] = '';
        $this->dataMainDocument['hashSignature'] = '';

        // Ajout de la griffe pour le document principal
        $this->dataMainDocument['signatures'] = [];

        $this->expectException(SignatureIsMandatoryProblem::class);
        $this->continueCircuitAction->execute(1, ["1" => [$this->dataMainDocument]], []);
    }

    public function testCannotExecuteActionAsSignatoryWithoutCertificateOnCertifiedDocument(): void
    {
        $this->dataMainDocument['certificate'] = '';
        $this->dataMainDocument['hashSignature'] = '';

        $externalState = ["hasDigitalSignature" => true];
        $this->mainResourceRepositoryMock->mainResource
            ->setExternalDocumentId(99)
            ->setExternalState($externalState);


        $this->expectException(DigitalSignatureIsMandatoryProblem::class);
        $this->continueCircuitAction->execute(1, ["1" => [$this->dataMainDocument]], []);
    }

    public function testCannotExecuteActionAsVisaUserWithStampOnCertifiedDocument(): void
    {
        $this->visaWorkflowRepositoryMock->listInstance->setItemMode(Mode::VISA);

        $this->dataMainDocument['certificate'] = '';
        $this->dataMainDocument['hashSignature'] = '';

        $externalState = ["hasDigitalSignature" => true];
        $this->mainResourceRepositoryMock->mainResource
            ->setExternalDocumentId(99)
            ->setExternalState($externalState);

        $this->expectException(StampSignatureForbiddenProblem::class);
        $this->continueCircuitAction->execute(1, ["1" => [$this->dataMainDocument]], []);
    }

    public function testCanExecuteActionAsVisaUserWithStampOnNotCertifiedDocument(): void
    {
        $this->visaWorkflowRepositoryMock->listInstance->setItemMode(Mode::VISA);
        $externalState = ["hasDigitalSignature" => false];
        $this->mainResourceRepositoryMock->mainResource
            ->setExternalState($externalState);

        $result = $this->continueCircuitAction->execute(1, ["1" => [$this->dataMainDocument]], []);
        $this->assertTrue($result);
    }

    public function currentStepPayloadDataWithoutDigitalCertificateProvider(): array
    {
        return [
            'Of main document' => [
                'inputData' => [
                    "digitalCertificate" => false, $this->dataMainDocument['resId'] => [$this->dataMainDocument]
                ]
            ],
            'Of attachment' => [
                'inputData' => [
                    "digitalCertificate" => false, $this->dataAttachment['resId'] => [$this->dataAttachment]
                ]
            ]
        ];
    }

    /**
     * @dataProvider currentStepPayloadDataWithoutDigitalCertificateProvider
     */
    public function testCanChangeTheCurrentWorkflowStepFromSignatoryToViewerWithNoDigitalCertificate(
        array $inputData
    ): void {
        unset(
            $this->dataMainDocument['certificate'],
            $this->dataMainDocument['hashSignature'],
            $this->dataMainDocument['signatureContentLength'],
            $this->dataMainDocument['cookieSession'],
            $this->dataMainDocument['tmpUniqueId']
        );
        $this->dataMainDocument['signatures'] = [];

        $listinstance = (new ListInstance())
            ->setResId(1)
            ->setSequence(1)
            ->setItemId(10)
            ->setItemType('user_id')
            ->setSignatory(false)
            ->setItemMode(Mode::SIGN)
            ->setRequestedSignature(true)
            ->setListInstanceId(1);
        $this->visaWorkflowRepositoryMock->listInstance = $listinstance;
        $this->visaWorkflowRepositoryMock->activeWorkflow[] = $listinstance;

        $this->continueCircuitAction->execute(1, $inputData, []);

        $this->assertNotEmpty($this->updateWorkflowInSignatureBookSpy->passedResourcesWithListInstance);
        $this->assertSame(
            Mode::VISA->value,
            $this->updateWorkflowInSignatureBookSpy->passedResourcesWithListInstance[1][0]['item_mode']
        );
    }

    public function currentStepPayloadDataWithDigitalCertificateProvider(): array
    {
        return [
            'Of main document' => [
                'inputData' => [
                    "digitalCertificate" => true, $this->dataMainDocument['resId'] => [$this->dataMainDocument]
                ]
            ],
            'Of attachment' => [
                'inputData' => [
                    "digitalCertificate" => true, $this->dataAttachment['resId'] => [$this->dataAttachment]
                ]
            ]
        ];
    }

    /**
     * @dataProvider currentStepPayloadDataWithDigitalCertificateProvider
     */
    public function testCannotChangeTheCurrentWorkflowStepFromSignatoryToViewerWithDigitalCertificate(
        array $inputData
    ): void {
        $listinstance = (new ListInstance())
            ->setResId(1)
            ->setSequence(1)
            ->setItemId(10)
            ->setItemType('user_id')
            ->setSignatory(false)
            ->setItemMode(Mode::SIGN)
            ->setRequestedSignature(true)
            ->setListInstanceId(1);
        $this->visaWorkflowRepositoryMock->listInstance = $listinstance;
        $this->visaWorkflowRepositoryMock->activeWorkflow[] = $listinstance;

        $this->continueCircuitAction->execute(1, $inputData, []);

        $this->assertEmpty(
            $this->updateWorkflowInSignatureBookSpy->passedResourcesWithListInstance
        );
    }
}
