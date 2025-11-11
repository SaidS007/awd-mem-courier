<?php

/**
 * Copyright Maarch since 2008 under licence GPLv3.
 * See LICENCE.txt file at the root folder for more details.
 * This file is part of Maarch software.
 *
 */

/**
 * @brief continueCircuitAction class
 * @author dev@maarch.org
 */

namespace MaarchCourrier\SignatureBook\Application\Action;

use MaarchCourrier\Attachment\Domain\Attachment;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceInterface;
use MaarchCourrier\Core\Domain\MainResource\Port\MainResourceRepositoryInterface;
use MaarchCourrier\Core\Domain\User\Port\CurrentUserInterface;
use MaarchCourrier\MainResource\Domain\MainResource;
use MaarchCourrier\SignatureBook\Domain\Mode;
use MaarchCourrier\SignatureBook\Domain\Port\SignatureServiceConfigLoaderInterface;
use MaarchCourrier\SignatureBook\Domain\Port\SignatureServiceInterface;
use MaarchCourrier\SignatureBook\Domain\Port\VisaWorkflowRepositoryInterface;
use MaarchCourrier\SignatureBook\Domain\Port\Workflow\UpdateWorkflowInSignatureBookInterface;
use MaarchCourrier\SignatureBook\Domain\Problem\CurrentTokenIsNotFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\DataToBeSentToTheParapheurAreEmptyProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\DigitalSignatureIsMandatoryProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\NoDocumentsInSignatureBookForThisId;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureIsMandatoryProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureNotAppliedProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\SignatureBookNoConfigFoundProblem;
use MaarchCourrier\SignatureBook\Domain\Problem\StampSignatureForbiddenProblem;
use MaarchCourrier\SignatureBook\Domain\SignatureBookResource;

class ContinueCircuitAction
{
    /**
     * @param CurrentUserInterface $currentUser
     * @param SignatureServiceInterface $signatureService
     * @param SignatureServiceConfigLoaderInterface $signatureServiceConfigLoader
     * @param MainResourceRepositoryInterface $mainResourceRepository
     * @param VisaWorkflowRepositoryInterface $visaWorkflowRepository
     * @param bool $isNewSignatureBookEnabled
     * @param UpdateWorkflowInSignatureBookInterface $updateWorkflowInSignatureBook
     */
    public function __construct(
        private readonly CurrentUserInterface $currentUser,
        private readonly SignatureServiceInterface $signatureService,
        private readonly SignatureServiceConfigLoaderInterface $signatureServiceConfigLoader,
        private readonly MainResourceRepositoryInterface $mainResourceRepository,
        private readonly VisaWorkflowRepositoryInterface $visaWorkflowRepository,
        private readonly bool $isNewSignatureBookEnabled,
        private readonly UpdateWorkflowInSignatureBookInterface $updateWorkflowInSignatureBook
    ) {
    }

    /**
     * @param  Mode  $currentRole
     * @param  MainResourceInterface  $mainResource
     * @param  array  $data
     * @return void
     * @throws DigitalSignatureIsMandatoryProblem
     * @throws SignatureIsMandatoryProblem
     * @throws StampSignatureForbiddenProblem
     */
    private function validateBeforeExecution(Mode $currentRole, MainResourceInterface $mainResource, array $data): void
    {
        foreach ($data[$mainResource->getResId()] as $document) {
            if ($currentRole == Mode::SIGN) {
                if (empty($document['certificate']) && empty($document['signatures'])) {
                    throw new SignatureIsMandatoryProblem();
                }

                if (empty($document['certificate']) && $mainResource->getHasDigitalSignature()) {
                    throw new DigitalSignatureIsMandatoryProblem();
                }
            } elseif (!empty($document['signatures']) && $mainResource->getHasDigitalSignature()) {
                throw new StampSignatureForbiddenProblem();
            }
        }
    }

    /**
     * @param int $resId
     * @param array $data
     * @param array $note
     *
     * @return bool
     * @throws CurrentTokenIsNotFoundProblem
     * @throws DataToBeSentToTheParapheurAreEmptyProblem
     * @throws DigitalSignatureIsMandatoryProblem
     * @throws NoDocumentsInSignatureBookForThisId
     * @throws SignatureBookNoConfigFoundProblem
     * @throws SignatureIsMandatoryProblem
     * @throws SignatureNotAppliedProblem
     * @throws StampSignatureForbiddenProblem
     */
    public function execute(int $resId, array $data, array $note): bool
    {
        if (!$this->isNewSignatureBookEnabled) {
            return true;
        }

        $signatureBook = $this->signatureServiceConfigLoader->getSignatureServiceConfig();
        if ($signatureBook === null) {
            throw new SignatureBookNoConfigFoundProblem();
        }
        $accessToken = $this->currentUser->getCurrentUserToken();
        if (empty($accessToken)) {
            throw new CurrentTokenIsNotFoundProblem();
        }

        if (!isset($data[$resId])) {
            throw new NoDocumentsInSignatureBookForThisId();
        }

        $mainResource = $this->mainResourceRepository->getMainResourceByResId($resId);
        $currentStepVisaWorkflow = $this->visaWorkflowRepository->getCurrentStepByMainResource($mainResource);

        $currentRole = $currentStepVisaWorkflow->getItemMode();
        $this->validateBeforeExecution($currentRole, $mainResource, $data);

        foreach ($data[$resId] as $document) {
            $isUserSignatory = false;
            $missingData = [];
            $applySuccess = [];
            if ($currentRole !== Mode::VISA && !empty($data['digitalCertificate'])) {
                $isUserSignatory = true;
                $requiredData = [
                    'resId',
                    'documentId',
                    'hashSignature',
                    'certificate',
                    'signatureContentLength',
                    'signatureFieldName',
                    'cookieSession'
                ];

                foreach ($requiredData as $requiredDatum) {
                    if (empty($document[$requiredDatum])) {
                        $missingData[] = $requiredDatum;
                    }
                }

                if (!empty($missingData)) {
                    throw new DataToBeSentToTheParapheurAreEmptyProblem($missingData);
                }

                $document['documentId'] = intval($document['documentId'] ?? 0);

                $resourceToSign = [
                    'resId' => $document['resId']
                ];

                if (isset($document['isAttachment']) && $document['isAttachment']) {
                    $resourceToSign['resIdMaster'] = $resId;
                }

                $applySuccess = $this->signatureService
                    ->setConfig($signatureBook)
                    ->applySignature(
                        $document['documentId'],
                        $document['hashSignature'],
                        $document['signatures'] ?? [],
                        $document['certificate'],
                        $document['signatureContentLength'],
                        $document['signatureFieldName'],
                        $document['tmpUniqueId'] ?? null,
                        $accessToken,
                        $document['cookieSession'],
                        $resourceToSign
                    );
            } else {
                $requiredData = [
                    'resId'
                ];

                if (!empty($document['signatures'])) {
                    $requiredData[] = 'documentId';
                }

                foreach ($requiredData as $requiredDatum) {
                    if (empty($document[$requiredDatum])) {
                        $missingData[] = $requiredDatum;
                    }
                }

                if (!empty($missingData)) {
                    throw new DataToBeSentToTheParapheurAreEmptyProblem($missingData);
                }

                $document['documentId'] = intval($document['documentId'] ?? 0);

                $resourceToSign = [
                    'resId' => $document['resId']
                ];

                if (isset($document['isAttachment']) && $document['isAttachment']) {
                    $resourceToSign['resIdMaster'] = $resId;
                }

                if (!empty($document['signatures'])) {
                    $isUserSignatory = true;
                }

                // Update the current step from signatory to validator
                // If user is a signatory and have no digital certificate selected
                $mainResource = (new MainResource())
                    ->setResId($resId);
                $currentStep = $this->visaWorkflowRepository->getCurrentStepByMainResource($mainResource);

                if (
                    $currentStep !== null &&
                    $currentStep->getItemType() == 'user_id' &&
                    !$currentStep->isSignatory() &&
                    $currentStep->isRequestedSignature() &&
                    $currentStep->getItemMode() === Mode::SIGN
                ) {
                    // if true : get, change and update current workflow for all documents
                    $workflowList = $this->visaWorkflowRepository->getActiveVisaWorkflowByMainResource($mainResource);

                    // only change the current step but keep the others
                    $listInstancesForSignatureBook = [];
                    foreach ($workflowList as $key => $workflow) {
                        $listInstancesForSignatureBook[$mainResource->getResId()][$key] = [
                            'item_id'   => $workflow->getItemId(),
                            'item_mode' => $workflow->getItemMode()->value
                        ];
                        if ($key === 0) {
                            $resId = $mainResource->getResId();
                            $listInstancesForSignatureBook[$resId][$key]['item_mode'] = Mode::VISA->value;
                        }
                    }

                    // which signature book resource to apply the update
                    if (empty($document['isAttachment'] ?? false)) {
                        $mainResource->setExternalDocumentId($document['documentId']);
                        $resourceToUpdate = SignatureBookResource::createFromMainResource($mainResource);
                    } else {
                        $resourceToUpdate = SignatureBookResource::createFromAttachment(
                            (new Attachment())
                                ->setResId($document['resId'])
                                ->setMainResource($mainResource)
                                ->setExternalDocumentId($document['documentId'])
                        );
                    }

                    // send the update workflow
                    $this->updateWorkflowInSignatureBook->update($listInstancesForSignatureBook, [$resourceToUpdate]);
                }


                if ($document['documentId'] !== 0) {
                    $applySuccess = $this->signatureService
                        ->setConfig($signatureBook)
                        ->applySignature(
                            $document['documentId'],
                            null,
                            $document['signatures'] ?? [],
                            null,
                            null,
                            null,
                            $document['tmpUniqueId'] ?? null,
                            $accessToken,
                            null,
                            $resourceToSign
                        );
                }
            }

            if ($isUserSignatory) {
                $this->visaWorkflowRepository->updateListInstance($currentStepVisaWorkflow, ['signatory' => 'true']);
            }

            if (!empty($applySuccess['errors'])) {
                $error = $applySuccess['errors'];
                if (!empty($applySuccess['context'])) {
                    $error .= " (Message = " . $applySuccess['context']['message'] . ")";
                }
                throw new SignatureNotAppliedProblem($error);
            }
        }

        return true;
    }
}
