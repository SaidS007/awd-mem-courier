import { Component, OnInit, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { NotificationService } from '@service/notification/notification.service';
import { CdkDragDrop, moveItemInArray } from '@angular/cdk/drag-drop';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { FunctionsService } from '@service/functions.service';
import { DomSanitizer } from '@angular/platform-browser';
import { PrivilegeService } from '@service/privileges.service';
import { ExternalSignatoryBookManagerService } from '@service/externalSignatoryBook/external-signatory-book-manager.service';
import { catchError, tap } from 'rxjs/operators'; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe | Ajout de catchError
import { of } from "rxjs"; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe

@Component({
    templateUrl: 'summary-sheet.component.html',
    styleUrls: ['summary-sheet.component.scss'],
    providers: [ExternalSignatoryBookManagerService],
    standalone: false
})
export class SummarySheetComponent implements OnInit {

    loading: boolean = false;
    withQrcode: boolean = true;
    paramMode: boolean = false;
    allToggled: boolean | null = null; // EDISSYUM - AMO01 Rajout d'un Toggle général pour les champs de la fiche de liaison

    dataAvailable: any[] = [
        {
            id: 'primaryInformations',
            unit: 'primaryInformations',
            label: this.translate.instant('lang.primaryInformations'),
            css: 'col-md-6 text-left',
            desc: [
                this.translate.instant('lang.mailDate'),
                this.translate.instant('lang.arrivalDate'),
                this.translate.instant('lang.nature'),
                this.translate.instant('lang.creation_date'),
                this.translate.instant('lang.mailType'),
                this.translate.instant('lang.initiator')
            ],
            enabled: true
        },
        {
            id: 'senderRecipientInformations',
            unit: 'senderRecipientInformations',
            label: this.translate.instant('lang.senderRecipientInformations'),
            css: 'col-md-6 text-left',
            desc: [
                this.translate.instant('lang.senders'),
                this.translate.instant('lang.recipients')
            ],
            enabled: true
        },
        {
            id: 'secondaryInformations',
            unit: 'secondaryInformations',
            label: this.translate.instant('lang.secondaryInformations'),
            css: 'col-md-6 text-left',
            desc: [
                this.translate.instant('lang.category_id'),
                this.translate.instant('lang.status'),
                this.translate.instant('lang.priority'),
                this.translate.instant('lang.processLimitDate'),
                this.translate.instant('lang.retentionRuleFrozen'),
                this.translate.instant('lang.bindingMail'),
                this.translate.instant('lang.customFieldsAdmin')
            ],
            enabled: true
        },
        {
            id: 'systemTechnicalFields',
            unit: 'systemTechnicalFields',
            label: this.translate.instant('lang.systemTechnicalFields'),
            css: 'col-md-6 text-left',
            desc: [
                this.translate.instant('lang.initiator'),
                this.translate.instant('lang.creationDate'),
                this.translate.instant('lang.size'),
                this.translate.instant('lang.format'),
                this.translate.instant('lang.filename'),
                this.translate.instant('lang.docserverPathFile'),
                this.translate.instant('lang.fingerprint'),
                this.translate.instant('lang.fulltext')
            ],
            enabled: true
        },
        {
            id: 'customTechnicalFields',
            unit: 'customTechnicalFields',
            label: this.translate.instant('lang.customTechnicalFields'),
            css: 'col-md-6 text-left',
            desc: [],
            enabled: true
        },
        {
            id: 'diffusionList',
            unit: 'diffusionList',
            label: this.translate.instant('lang.diffusionList'),
            css: 'col-md-6 text-left',
            desc: [
                this.translate.instant('lang.dest_user'),
                this.translate.instant('lang.copyUsersEntities')
            ],
            enabled: true
        },
        {
            id: 'opinionWorkflow',
            unit: 'opinionWorkflow',
            label: this.translate.instant('lang.avis'),
            css: 'col-md-4 text-center',
            desc: [
                this.translate.instant('lang.firstname') + ' ' + this.translate.instant('lang.lastname') + ' (' + this.translate.instant('lang.destination').toLowerCase() + ')',
                this.translate.instant('lang.role'),
                this.translate.instant('lang.processDate')
            ],
            enabled: true
        },
        {
            id: 'visaWorkflow',
            unit: 'visaWorkflow',
            label: this.translate.instant('lang.visaWorkflow'),
            css: 'col-md-4 text-center',
            desc: [
                this.translate.instant('lang.firstname') + ' ' + this.translate.instant('lang.lastname'),
                this.translate.instant('lang.role'),
                this.translate.instant('lang.processDate')
            ],
            enabled: true
        },
        {
            id: 'visaWorkflowMaarchParapheur',
            unit: 'visaWorkflowMaarchParapheur',
            label: this.translate.instant('lang.maarchParapheurWorkflow'),
            css: 'col-md-4 text-center',
            desc: [
                this.translate.instant('lang.firstname') + ' ' + this.translate.instant('lang.lastname'),
                this.translate.instant('lang.role'),
                this.translate.instant('lang.processDate')
            ],
            enabled: true
        },
        // EDISSYUM - AMO01 Dissocier les annotations par type + Adapter le paramètre defaultStatusSummarySheet | Commenter l'objet 'notes'
        // {
        //     id: 'notes',
        //     unit: 'notes',
        //     label: this.translate.instant('lang.notes'),
        //     css: 'col-md-4 text-center',
        //     desc: [
        //         this.translate.instant('lang.firstname') + ' ' + this.translate.instant('lang.lastname'),
        //         this.translate.instant('lang.creation_date'),
        //         this.translate.instant('lang.content')
        //     ],
        //     enabled: true
        // },
        // END EDISSYUM - AMO01
        {
            id: 'workflowHistory',
            unit: 'workflowHistory',
            label: this.translate.instant('lang.history'),
            css: 'col-md-4 text-center',
            desc: [],
            enabled: true
        },
        {
            id: 'trafficRecords',
            unit: 'trafficRecords',
            label: this.translate.instant('lang.trafficRecordSummarySheet'),
            css: 'col-md-4 text-center',
            desc: [],
            enabled: true
        }
    ];

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        public dialogRef: MatDialogRef<SummarySheetComponent>,
        public externalSignatoryBook: ExternalSignatoryBookManagerService,
        @Inject(MAT_DIALOG_DATA) public data: any,
        public functions: FunctionsService,
        private privilegeService: PrivilegeService,
        private notify: NotificationService,
        private sanitizer: DomSanitizer
    ) { }

    ngOnInit(): void {
        this.paramMode = !this.functions.empty(this.data.paramMode);
        this.http.get('../rest/parameters').pipe(
            tap((data: any) => {
                // EDISSYUM - AMO01 Rajout d'un paramètre pour choisir le statut par défaut des champs de la fiche de liaison
                if(this.data.summarySheetRaw) {
                    this.formatSummarySheetFields(this.data.summarySheetRaw);
                } else {
                    this.http.get('../rest/parameters/defaultStatusSummarySheet').pipe(
                        tap((data: any) => {
                            const rawSummarySheet = JSON.parse(data.parameter.param_value_string);
                            this.formatSummarySheetFields(rawSummarySheet);
                        }),
                        catchError((err: any) => {
                            this.notify.handleSoftErrors(err);
                            return of(false);
                        })
                    ).subscribe();
                }
                // END EDISSYUM - AMO01

                const trafficRecordsInfo = data.parameters.filter((item: any) => ('traffic_record_summary_sheet' === item.id && !this.functions.empty(item.param_value_string)));
                if (trafficRecordsInfo.length === 0) {
                    this.dataAvailable = this.dataAvailable.filter((item: any) => item.id !== 'trafficRecords');
                } else {
                    this.dataAvailable = this.dataAvailable.map((item: any) => {
                        if (item.id === 'trafficRecords') {
                            item.advanced_desc = this.sanitizer.bypassSecurityTrustHtml(trafficRecordsInfo[0].param_value_string);
                        }
                        return item;
                    });
                }
                this.updateAllToggledStatus(); // EDISSYUM - AMO01 Rajout d'un Toggle général pour les champs de la fiche de liaison
            })
        ).subscribe();

        if (!this.functions.empty(this.externalSignatoryBook.signatoryBookEnabled)) {
            if (!this.externalSignatoryBook.canViewWorkflow()) {
                this.dataAvailable = this.dataAvailable.filter((item: any) => item.id !== 'visaWorkflowMaarchParapheur');
            }
        }

        if (!this.privilegeService.hasCurrentUserPrivilege('view_doc_history') && !this.privilegeService.hasCurrentUserPrivilege('view_full_history')) {
            this.dataAvailable = this.dataAvailable.filter((item: any) => item.id !== 'workflowHistory');
        }
        if (!this.privilegeService.hasCurrentUserPrivilege('view_technical_infos')) {
            this.dataAvailable = this.dataAvailable.filter((item: any) => item.id !== 'systemTechnicalFields' && item.id !== 'customTechnicalFields');
        }
        this.updateAllToggledStatus(); // EDISSYUM - AMO01 Rajout d'un Toggle général pour les champs de la fiche de liaison
    }

    drop(event: CdkDragDrop<string[]>) {
        if (event.previousContainer === event.container) {
            moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
        }
    }

    // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
    formatSummarySheetFields(rawSummarySheet: any) {
        this.dataAvailable = this.dataAvailable.map((item: any) => {
            item.enabled = rawSummarySheet[item.id];
            return item;
        });
        this.updateAllToggledStatus();
    }
    // END EDISSYUM - (AMI01 + AMO01)

    genSummarySheets() {
        this.loading = true;

        this.http.post('../rest/resourcesList/summarySheets', { units: this.formatSummarySheet(), resources: this.data.selectedRes }, { responseType: 'blob' })
            .subscribe((data) => {
                if (data.type !== 'text/html') {
                    const downloadLink = document.createElement('a');
                    downloadLink.href = window.URL.createObjectURL(data);
                    downloadLink.setAttribute('download', this.functions.getFormatedFileName(this.translate.instant('lang.summarySheetsAlt'), 'pdf'));
                    document.body.appendChild(downloadLink);
                    downloadLink.click();
                } else {
                    alert(this.translate.instant('lang.tooMuchDatas'));
                }

                this.loading = false;
            }, (err: any) => {
                this.notify.handleBlobErrors(err);
            });
    }

    formatSummarySheet() {
        const currElemData: any[] = [];

        if (this.withQrcode) {
            currElemData.push({
                unit: 'qrcode',
                label: '',
            });
        }
        this.dataAvailable.forEach((element: any) => {
            if (element.enabled) {
                currElemData.push({
                    unit: element.unit,
                    label: element.label,
                });
            }
        });

        return currElemData;
    }

    toggleQrcode() {
        this.withQrcode = !this.withQrcode;
    }

    addCustomUnit() {
        this.dataAvailable.push({
            id: 'freeField_' + this.dataAvailable.length,
            unit: 'freeField',
            label: this.translate.instant('lang.comments'),
            css: 'col-md-12 text-left',
            desc: [
                this.translate.instant('lang.freeNote')
            ],
            enabled: true
        });
        this.updateAllToggledStatus(); // EDISSYUM - AMO01 Rajout d'un Toggle général pour les champs de la fiche de liaison
    }

    removeCustomUnit(i: number) {
        this.dataAvailable.splice(i, 1);
        this.updateAllToggledStatus(); // EDISSYUM - AMO01 Rajout d'un Toggle général pour les champs de la fiche de liaison
    }

    closeModalWithParams() {
        this.dialogRef.close(this.formatSummarySheet());
    }

    // EDISSYUM - AMO01 Rajout d'un Toggle général pour les champs de la fiche de liaison
    toggleAll() {
        const newValue = this.allToggled !== true;
        this.dataAvailable.forEach(item => item.enabled = newValue);
        this.updateAllToggledStatus();
    }

    updateAllToggledStatus() {
        const allEnabled = this.dataAvailable.every(item => item.enabled);
        const allDisabled = this.dataAvailable.every(item => !item.enabled);

        if (allEnabled) {
            this.allToggled = true;
        } else if (allDisabled) {
            this.allToggled = false;
        } else {
            this.allToggled = null;
        }
    }
    // END EDISSYUM - AMO01
}
