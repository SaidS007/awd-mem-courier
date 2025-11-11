import { Component, OnInit, Inject, ViewChild, ChangeDetectorRef, EventEmitter, Output } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { NotificationService } from '@service/notification/notification.service';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog'; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe - Ajout de MatDialog
import { HttpClient } from '@angular/common/http';
import { NoteEditorComponent } from '../../notes/note-editor.component';
import { MaarchParaphComponent } from './maarch-paraph/maarch-paraph.component';
import { IParaphComponent } from './i-paraph/i-paraph.component';
import { IxbusParaphComponent } from './ixbus-paraph/ixbus-paraph.component';
import { tap, finalize, catchError } from 'rxjs/operators';
import { of } from 'rxjs';
import { SessionStorageService } from '@service/session-storage.service';
import { ExternalSignatoryBookManagerService } from '@service/externalSignatoryBook/external-signatory-book-manager.service';
import { FunctionsService } from '@service/functions.service';
import { FastParaphComponent } from './fast-paraph/fast-paraph.component';
import { AuthService } from '@service/auth.service';
import { AppService } from '@service/app.service';
import { AttachmentsListComponent } from '@appRoot/attachments/attachments-list.component';
import { MatSidenav } from '@angular/material/sidenav';
import { UserWorkflow } from '@models/user-workflow.model';
import { BluewayParaphComponent } from './blueway-paraph/blueway-paraph.component'; // EDISSYUM - PYB01 Ajout du connecteur Blueway
import { PastellParaphComponent } from './pastell-paraph/pastell-paraph.component'; // EDISSYUM - PYB01 Ajout du connecteur Pastell
import { LexPersonaComponent } from './lex-persona/lex-persona.component'; // EDISSYUM - YAA01 Ajout du connecteur LexPersona
import { SummarySheetComponent } from '../../list/summarySheet/summary-sheet.component'; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
import { PrivilegeService } from "@service/privileges.service"; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe

@Component({
    templateUrl: 'send-external-signatory-book-action.component.html',
    styleUrls: ['send-external-signatory-book-action.component.scss'],
    providers: [ExternalSignatoryBookManagerService],
    standalone: false
})
export class SendExternalSignatoryBookActionComponent implements OnInit {

    @ViewChild('noteEditor', { static: false }) noteEditor: NoteEditorComponent;
    @ViewChild('externalSignatoryBookComponent', { static: false }) externalSignatoryBookComponent: MaarchParaphComponent;
    @ViewChild('fastParapheur', { static: false }) fastParapheur: FastParaphComponent;
    @ViewChild('iParapheur', { static: false }) iParapheur: IParaphComponent;
    @ViewChild('ixbus', { static: false }) ixbus: IxbusParaphComponent;
    @ViewChild('attachmentsList', { static: false }) attachmentsList: AttachmentsListComponent;
    @ViewChild('snav2', { static: false }) public snav2: MatSidenav;
    @ViewChild('blueway', { static: false }) blueway: BluewayParaphComponent; // EDISSYUM - PYB01 Ajout du connecteur Blueway
    @ViewChild('pastell', { static: false }) pastell: PastellParaphComponent; // EDISSYUM - PYB01 Ajout du connecteur Pastell
    @ViewChild('lexPersona', { static: false }) lexPersona: LexPersonaComponent; // EDISSYUM - YAA01 Ajout du connecteur LexPersona



    @Output() sidenavStateChanged = new EventEmitter<boolean>();

    visaWorkflowClone: UserWorkflow[];

    loading: boolean = false;
    finalLoading: boolean = false; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe

    additionalsInfos: any = {
        destinationId: '',
        users: [],
        attachments: [],
        noAttachment: []
    };
    resourcesToSign: any[] = [];
    resourcesMailing: any[] = [];
    availableResources: any[] = [];

    externalSignatoryBookDatas: any = {
        steps: [],
        objectSent: 'attachment'
    };

    integrationsInfo: any = {
        inSignatureBook: {
            icon: 'fas fa-file-signature'
        }
    };

    errors: any;

    mainDocumentSigned: boolean = false;
    // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
    summarySheet: any;
    summarySheetRaw: any;
    sendSummarySheet: boolean;
    summaryAttach: any = {};
    // END - EDISSYUM (AMI01 + AMO01)

    canGoToNextRes: boolean = false;
    showToggle: boolean = false;
    inLocalStorage: boolean = false;

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        public dialogRef: MatDialogRef<SendExternalSignatoryBookActionComponent>,
        public externalSignatoryBook: ExternalSignatoryBookManagerService,
        public functions: FunctionsService,
        public authService: AuthService,
        public appService: AppService,
        @Inject(MAT_DIALOG_DATA) public data: any,
        private notify: NotificationService,
        private changeDetectorRef: ChangeDetectorRef,
        private sessionStorage: SessionStorageService,
        private privilegeService: PrivilegeService, // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
        public dialog: MatDialog, // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
    ) {
    }

    async ngOnInit(): Promise<void> {
        this.loading = true;
        if (!this.functions.empty(this.authService?.externalSignatoryBook)) {
            await this.checkExternalSignatureBook();
            this.showToggle = this.data.additionalInfo.showToggle;
            this.canGoToNextRes = this.data.additionalInfo.canGoToNextRes;
            this.inLocalStorage = this.data.additionalInfo.inLocalStorage;
            if (this.data.resource.integrations['inSignatureBook']) {
                this.http.get(`../rest/resources/${this.data.resource.resId}/versionsInformations`).pipe(
                    tap((data: any) => {
                        this.mainDocumentSigned = data.SIGN.length !== 0;
                        if (!this.mainDocumentSigned) {
                            this.toggleDocToSign(true, this.data.resource, true);
                        }
                    }),
                    catchError((err: any) => {
                        this.notify.handleSoftErrors(err);
                        return of(false);
                    })
                ).subscribe();
            }
            // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
            this.http.get('../rest/parameters/sendSummarySheet').pipe(
                tap((data: any) => {
                    this.sendSummarySheet = data.parameter.param_value_int === 1;
                }),
                catchError((err: any) => {
                    this.notify.handleSoftErrors(err);
                    return of(false);
                })
            ).subscribe();

            this.http.get('../rest/parameters/defaultParapheurSummarySheet').pipe(
                tap((data: any) => {
                    const rawSummarySheet = JSON.parse(data.parameter.param_value_string);
                    this.summarySheetRaw = rawSummarySheet;
                    this.summarySheet = this.formatSummarySheetFromJson(rawSummarySheet);
                    this.data.summarySheet = this.summarySheet;
                }),
                catchError((err: any) => {
                    this.notify.handleSoftErrors(err);
                    return of(false);
                })
            ).subscribe();
            // END - EDISSYUM (AMI01 + AMO01)
        } else {
            this.dialogRef.close();
            this.notify.handleSoftErrors(this.translate.instant('lang.externalSignatoryBookNotEnabled'));
            this.loading = false;
            this.finalLoading = false; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
        }
    }

    async onSubmit() {
        if (this.hasEmptyOtpSignaturePosition()) {
            this.notify.error(this.translate.instant('lang.mustSign'));
        } else {
            this.loading = true;
            this.finalLoading = true; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
            if (this.data.resIds.length > 0) {
                // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
                if(this.sendSummarySheet) {
                    if(!this.summarySheet) {
                        this.openSummarySheet();
                        this.loading = false;
                        this.finalLoading = false;
                        return;
                    }
                    if(this.noteEditor.getNoteContent() !== '') {
                        const noteContent: string = `[${this.translate.instant('lang.visa').toUpperCase()}] ${this.noteEditor.getNoteContent()}`;
                        await this.noteEditor.setNoteContent(noteContent);
                        await this.noteEditor.addNote();
                    }
                    await this.createSummarySheet();
                    this.changeDetectorRef.detectChanges();
                } else if (this.summarySheet) {
                    delete this.data.summarySheet;
                }
                // END - EDISSYUM (AMI01 + AMO01)
                this.sessionStorage.checkSessionStorage(this.inLocalStorage, this.canGoToNextRes, this.data);
                this.executeAction();
            }
        }
    }

    // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
    formatSummarySheetFromJson(jsonData: any): any[] {
        const dataMap = {
            primaryInformations: this.translate.instant('lang.primaryInformations'),
            senderRecipientInformations: this.translate.instant('lang.senderRecipientInformations'),
            secondaryInformations: this.translate.instant('lang.secondaryInformations'),
            systemTechnicalFields: this.translate.instant('lang.systemTechnicalFields'),
            customTechnicalFields: this.translate.instant('lang.customTechnicalFields'),
            diffusionList: this.translate.instant('lang.diffusionList'),
            opinionWorkflow: this.translate.instant('lang.avis'),
            visaWorkflow: this.translate.instant('lang.visaWorkflow'),
            visaWorkflowMaarchParapheur: this.translate.instant('lang.maarchParapheurWorkflow'),
            globalNotes: this.translate.instant('lang.globalNotes'),
            avisNotes: this.translate.instant('lang.avisNotes'),
            visaNotes: this.translate.instant('lang.visaNotes'),
            workflowHistory: this.translate.instant('lang.history'),
            trafficRecords: this.translate.instant('lang.trafficRecordSummarySheet'),
        };

        this.http.get('../rest/parameters').pipe(
            tap((data: any) => {
                const trafficRecordsInfo = data.parameters.filter((item: any) => ('traffic_record_summary_sheet' === item.id && !this.functions.empty(item.param_value_string)));
                if (trafficRecordsInfo.length === 0) {
                    delete jsonData.trafficRecords;
                }
            })
        ).subscribe();

        if (!this.privilegeService.hasCurrentUserPrivilege('view_doc_history') && !this.privilegeService.hasCurrentUserPrivilege('view_full_history')) {
            delete jsonData.workflowHistory;
        }

        if (!this.privilegeService.hasCurrentUserPrivilege('view_technical_infos')) {
            delete jsonData.systemTechnicalFields;
            delete jsonData.customTechnicalFields;
        }

        return Object.keys(jsonData)
            .filter((key) => jsonData[key])
            .map((key) => ({
                unit: key,
                label: dataMap[key] || 'Champ inconnu',
            }));
    }
    // END - EDISSYUM (AMI01 + AMO01)

    async checkExternalSignatureBook() {
        this.loading = true;
        const data: any = await this.externalSignatoryBook.checkExternalSignatureBook(this.data);
        if (!this.functions.empty(data)) {
            this.additionalsInfos = data.additionalsInfos;
            if (this.additionalsInfos.attachments.length > 0) {
                this.resourcesMailing = data.additionalsInfos.attachments.filter((element: any) => element.mailing);
                this.availableResources = data.availableResources;
                this.availableResources.filter((element: any) => !element.mainDocument).forEach((element: any) => {
                    if (this.resourcesToSign.find((resource: any) => resource.resId === element.resId) === undefined) {
                        this.toggleDocToSign(true, element, false);
                    }
                });
            }
            this.errors = data.errors;
        } else {
            this.dialogRef.close();
        }
        this.loading = false;
    }

    executeAction() {
        let realResSelected: string[];
        let datas: any;
        if (this.functions.empty(this.externalSignatoryBook.signatoryBookEnabled)) {
            // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
            if (!this[this.authService.externalSignatoryBook.id]) {
                console.error(`Le composant ${this.authService.externalSignatoryBook.id} n'est pas initialisé !`);
                this.loading = false;
                this.finalLoading = false;
                return;
            }
            // END EDISSYUM (AMI01 + AMO01)
            realResSelected = this[this.authService.externalSignatoryBook.id].getRessources();
            datas = this[this.authService.externalSignatoryBook.id].getDatas();
        } else {
            realResSelected = this.externalSignatoryBook.getRessources(this.additionalsInfos);
            const workflow: any[] = this.externalSignatoryBookComponent.appExternalVisaWorkflow.getWorkflow();
            datas = this.externalSignatoryBook.getDatas(workflow, this.resourcesToSign, this.externalSignatoryBookComponent.appExternalVisaWorkflow.workflowType);
        }

        // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
        let note = this.noteEditor.getNote();
        if(this.sendSummarySheet) {
            note = {
                content: '',
                entities: []
            };
        }
        // END - EDISSYUM (AMI01 + AMO01)

        this.http.put(this.data.processActionRoute, {
            resources: realResSelected,
            // note: this.noteEditor.getNote(), // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe - Commenter la ligne originale
            note: note, // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe - Ajout de la variable note
            data: datas
        }).pipe(
            tap((data: any) => {
                if (!data) {
                    this.dialogRef.close(realResSelected);
                }
                if (data && data.errors != null) {
                    this.notify.error(data.errors);
                }
            }),
            finalize(() => this.loading = false),
            catchError((err: any) => {

                this.notify.handleSoftErrors(err);
                this.finalLoading = false; // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
                return of(false);
            })
        ).subscribe();
    }

    isValidAction(): boolean {
        if (!this.functions.empty(this.externalSignatoryBook.signatoryBookEnabled) && this.authService.externalSignatoryBook.integratedWorkflow) {
            return this.externalSignatoryBook.isValidParaph(
                this.additionalsInfos,
                this.externalSignatoryBookComponent?.appExternalVisaWorkflow.getWorkflow(),
                this.resourcesToSign,
                this.externalSignatoryBookComponent?.appExternalVisaWorkflow.getUserOtpsWorkflow()
            );
        } else {
            if (this[this.authService.externalSignatoryBook?.id] !== undefined) {
                return this[this.authService.externalSignatoryBook?.id].isValidParaph();
            } else {
                return false;
            }
        }
    }

    toggleIntegration(integrationId: string) {
        this.resourcesToSign = [];
        this.http.put('../rest/resourcesList/integrations', {
            resources: this.data.resIds,
            integrations: { [integrationId]: !this.data.resource.integrations[integrationId] }
        }).pipe(
            tap(async () => {
                this.data.resource.integrations[integrationId] = !this.data.resource.integrations[integrationId];

                if (!this.mainDocumentSigned) {
                    this.toggleDocToSign(this.data.resource.integrations[integrationId], this.data.resource, true);
                }
                await this.checkExternalSignatureBook();
                this.changeDetectorRef.detectChanges();
                if (!this.functions.empty(this.externalSignatoryBook.signatoryBookEnabled) && this.authService.externalSignatoryBook.integratedWorkflow) {
                    this.externalSignatoryBookComponent.appExternalVisaWorkflow.visaWorkflow.items = this.visaWorkflowClone;
                }
            }),
            catchError((err: any) => {
                this.notify.handleSoftErrors(err);
                return of(false);
            })
        ).subscribe();
    }

    toggleDocToSign(state: boolean, document: any, mainDocument: boolean = true) {
        if (state) {
            if (this.resourcesToSign.find((resource: any) => resource.resId === document.resId) === undefined) {
                this.resourcesToSign.push(
                    {
                        resId: document.resId,
                        chrono: document.chrono,
                        title: document.subject,
                        mainDocument: mainDocument,
                    });
            }
        } else {
            const index = this.resourcesToSign.map((item: any) => `${item.resId}_${item.mainDocument}`).indexOf(`${document.resId}_${mainDocument}`);
            this.resourcesToSign.splice(index, 1);
        }
    }

    hasEmptyOtpSignaturePosition(): boolean {
        if (this.authService.externalSignatoryBook.integratedWorkflow && this.externalSignatoryBook.allowedSignatoryBook.indexOf(this.authService.externalSignatoryBook?.id) > -1) {
            const externalUsers: any[] = this.externalSignatoryBookComponent.appExternalVisaWorkflow.visaWorkflow.items.filter((user: any) => user.item_id === null && user.role === 'sign' && user.externalInformations.type !== 'fast');
            if (externalUsers.length > 0) {
                let state: boolean = false;
                this.resourcesToSign.forEach((resource: any) => {
                    if (this.externalSignatoryBookComponent.appExternalVisaWorkflow.hasOtpNoSignaturePositionFromResource(resource)) {
                        state = true;
                    }
                });
                return state;
            }
        } else {
            return false;
        }
    }

    getTitle(): string {
        if (!this.functions.empty(this.authService.externalSignatoryBook)) {
            if (!this.functions.empty(this.authService.externalSignatoryBook?.from)) {
                return this.translate.instant('lang.' + this.authService.externalSignatoryBook?.from);
            } else {
                return this.translate.instant('lang.' + this.authService.externalSignatoryBook.id);
            }
        }
        return this.translate.instant('lang.sendToExternalSignatoryBook');
    }

    async afterAttachmentToggle(data: {id: string, attachments: any[]}) {
        await this.checkExternalSignatureBook();
        this.attachmentsList.setTaget(this.attachmentsList.currentIntegrationTarget);
        if (data.id === 'setInSignatureBook') {
            data.attachments.forEach((attachment: any) => {
                if (!attachment.signable || !attachment.inSignatureBook) {
                    const resource: any = this.resourcesToSign.find((resource: any) => resource.resId === attachment.resId);
                    if (resource !== undefined) {
                        this.toggleDocToSign(false, resource, false);
                    }
                }
            });
        }
    }

    getIntegratedAttachments(): number {
        return this.attachmentsList?.attachmentsClone.filter((attachment: any) => attachment.inSignatureBook && attachment.status === 'A_TRA').length;
    }

    onSidenavStateChanged(): void {
        this.snav2?.toggle();
        this.sidenavStateChanged.emit(this.snav2?.opened);
    }

    // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
    openSummarySheet(): void {
        const dialogRef = this.dialog.open(SummarySheetComponent, {
            panelClass: 'maarch-full-height-modal',
            width: '800px',
            data: {
                paramMode: true,
                summarySheetRaw: this.summarySheetRaw
            }
        });
        dialogRef.afterClosed().pipe(
            tap((data: any) => {
                if (data) {
                    this.summarySheet = data;
                }
                this.data.summarySheet = this.summarySheet;
            }),
            catchError((err: any) => {
                this.notify.handleSoftErrors(err);
                return of(false);
            })
        ).subscribe();
    }

    async createSummarySheet() {
        // EDISSYUM - (AMI01 + AMO01) Intégration fiche de liaison au parapheur externe
        for (const unit of this.data.summarySheet) {
            unit.sendSummarySheet = true;
        }
        // END - EDISSYUM (AMI01 + AMO01)
        return new Promise(resolve => {
            this.http.post('../rest/resourcesList/summarySheets?mode=base64', {
                units: this.data.summarySheet,
                resources: this.data.resIds
            })
                .pipe(
                    tap(async (sheetData: any) => {
                        await this.saveSummarySheet(sheetData.encodedDocument);
                        this.loading = false;
                        resolve(true);
                    }),
                    catchError((err) => {
                        this.notify.handleErrors(err);
                        resolve(false);
                        return of(false);
                    })
                ).subscribe();
        });
    }

    async saveSummarySheet(encodedDocument: any) {
        return new Promise(resolve => {
            const title = this.functions.getFormatedFileName(this.translate.instant('lang.summarySheet'));
            this.http.post('../rest/attachments', { resIdMaster: (!['string','number'].includes(typeof this.data.resIds) ? this.data.resIds[0] : this.data.resIds ), encodedFile: encodedDocument, type: 'summary_sheet', inSignatureBook: true, format: 'PDF', title: title })
                .pipe(
                    tap((dataAttachment: any) => {
                        this.summaryAttach['summarySheet'] = undefined;
                        if (!this.summaryAttach['attachments']) {
                            this.summaryAttach['attachments'] = [];
                        }
                        this.summaryAttach['attachments'].push({
                            id: dataAttachment.id,
                            label: title,
                            format: 'pdf',
                            title: title,
                            original: true
                        });
                        this.loading = false;
                        resolve(true);
                    }),
                    catchError((err) => {
                        this.notify.handleErrors(err);
                        resolve(false);
                        return of(false);
                    })
                )
                .subscribe();
        });
    }
    // END - EDISSYUM (AMI01 + AMO01)
}
