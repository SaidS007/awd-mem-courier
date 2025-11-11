import { HttpClient } from '@angular/common/http';
import { Component, EventEmitter, Input, OnDestroy, OnInit, Output, ViewChild, ViewContainerRef } from '@angular/core';
import { ActionsService } from '@appRoot/actions/actions.service';
import { MessageActionInterface } from '@models/actions.model';
import { Attachment, AttachmentInterface } from '@models/attachment.model';
import { TranslateService } from '@ngx-translate/core';
import { FunctionsService } from '@service/functions.service';
import { HeaderService } from '@service/header.service';
import { NotificationService } from '@service/notification/notification.service';
import { PluginManagerService } from '@service/plugin-manager.service';
import { Subscription, catchError, finalize, of, tap } from 'rxjs';
import { SignatureBookService } from "@appRoot/signatureBook/signature-book.service";
import { EditorManagerModalComponent } from "@appRoot/editor/modal/editor-manager-modal.component";
import { MatDialog } from "@angular/material/dialog";
import { filter } from "rxjs/operators";
import { MatDialogRef } from "@angular/material/dialog";
import { StampInterface } from '@models/signature-book.model';

@Component({
    selector: 'app-maarch-sb-content',
    templateUrl: 'signature-book-content.component.html',
    styleUrls: ['signature-book-content.component.scss'],
    standalone: false
})
export class MaarchSbContentComponent implements OnInit, OnDestroy {
    @ViewChild('myPlugin', { read: ViewContainerRef, static: true }) myPlugin: ViewContainerRef;

    @Input() position: 'left' | 'right' = 'right';

    @Output() documentChangeEnd = new EventEmitter<any>();
    @Output() documentLoaded = new EventEmitter<boolean>();

    editDocumentAction = new EventEmitter<boolean>();

    subscription: Subscription;

    subscriptionDocument: Subscription;

    documentData: AttachmentInterface;
    currentIndexDocument: number = 0;

    documentType: 'attachments' | 'resources';

    documentContent: Blob = null;

    loading: boolean = false;

    pluginInstance: any = false;

    constructor(
        public functionsService: FunctionsService,
        private http: HttpClient,
        private actionsService: ActionsService,
        private notificationService: NotificationService,
        private pluginManagerService: PluginManagerService,
        private translateService: TranslateService,
        private headerService: HeaderService,
        private signatureBookService: SignatureBookService,
        public dialog: MatDialog,
    ) {
        this.subscription = this.actionsService
            .catchActionWithData()
            .pipe(
                tap(async (res: MessageActionInterface) => {
                    if (res.id === 'selectedStamp') {
                        if (this.pluginInstance) {
                            const signContent = await this.getSignatureContent(res.data.contentUrl);
                            this.pluginInstance.addStamp(signContent);
                        }
                    } else if (res.id === 'attachmentSelected' && this.position === res.data.position) {
                        this.currentIndexDocument = res.data.resIndex ?? 0;
                        this.initDocument();
                    }
                }),
                catchError((err: any) => {
                    this.notificationService.handleSoftErrors(err);
                    return of(false);
                })
            )
            .subscribe();
    }

    ngOnInit(): void {
        this.initDocument();
    }

    async initDocument(): Promise<void> {
        this.loading = true;
        this.subscriptionDocument?.unsubscribe();

        if (this.position === 'right' && this.signatureBookService.selectedDocToSign.index !== null) {
            await this.initDocToSign();
        } else if (this.position === 'left' && this.signatureBookService.selectedAttachment.index !== null) {
            await this.initAnnexe();
        }

        this.documentType = this.documentData?.isAttachment ? 'attachments' : 'resources';
        this.loading = false;
    }

    initAnnexe(): Promise<true> {
        return new Promise((resolve) => {
            this.documentData = this.signatureBookService.selectedAttachment.attachment;
            this.pluginInstance = null;
            this.pluginManagerService.destroyPlugin(this.myPlugin);
            setTimeout(() => {
                resolve(true);
            }, 0)
        });

    }

    async initDocToSign(): Promise<void> {
        this.documentData = this.signatureBookService.selectedDocToSign.attachment;
        const stamps: StampInterface[] = this.signatureBookService.docsToSign.find((attachment: Attachment) => attachment.resId === this.documentData.resId)?.stamps ?? [];
        await this.loadContent();
        if (this.pluginInstance) {
            this.pluginInstance.loadDocument({
                fileName: this.documentData.title,
                content: this.documentContent,
            }, stamps);
        } else {
            this.initPlugin();
        }
    }

    ngOnDestroy(): void {
        // unsubscribe to ensure no memory leaks
        this.subscription.unsubscribe();
        this.subscriptionDocument?.unsubscribe();
    }

    async initPlugin(): Promise<void> {
        const data: any = {
            file: {
                fileName: this.documentData.title,
                content: this.documentContent,
            },
            email: this.headerService.user.mail,
            currentLang: this.translateService.instant('lang.language'),
            canEditOriginalDocument: this.signatureBookService.canUpdateResources || this.documentData.canUpdate,
            documentChangeEnd: this.documentChangeEnd,
            editDocumentAction: this.editDocumentAction,
            documentLoaded: this.documentLoaded
        };
        this.pluginInstance = await this.pluginManagerService.initPlugin('maarch-plugins-pdftron', this.myPlugin, data);
        this.documentChangeEnd.pipe(
            tap((data: any) => {
                const index: number = this.signatureBookService.docsToSign.indexOf(this.documentData);
                this.signatureBookService.docsToSign[index].stamps = data.stamps;

                this.documentData.stamps = data.stamps;
                this.signatureBookService.docsToSignWithStamps = this.signatureBookService.docsToSignWithStamps.concat([this.documentData]);

                // Filter the docsToSignWithStamps array to remove duplicate entries based on resId
                this.signatureBookService.docsToSignWithStamps = this.signatureBookService.docsToSignWithStamps.filter((resource: Attachment, index: number, self: Attachment[]) =>
                // Keep the current resource only if it is the first occurrence of this resId in the array
                    index === self.findIndex((t) => t.resId == resource.resId)
                );
            })
        ).subscribe();
        this.editDocumentAction.pipe(
            tap(() => {
                this.openDocumentEditor();
            })
        ).subscribe();

        this.documentLoaded.pipe(
            tap((event: boolean) => {
                if (event) {
                    const index: number = this.signatureBookService.docsToSign.indexOf(this.documentData);
                    const docWithStamp: Attachment = this.signatureBookService.docsToSignWithStamps.find((attachment: Attachment) => attachment.resId === this.documentData.resId);
                    if (!this.functionsService.empty(docWithStamp)) {
                        this.signatureBookService.docsToSign[index].stamps = docWithStamp.stamps;
                        this.pluginInstance.loadStamps(docWithStamp.stamps);
                    }
                }
            })
        ).subscribe();
    }

    getLabel(): string {
        return !this.functionsService.empty(this.documentData?.chrono)
            ? `${this.documentData?.chrono}: ${this.documentData?.title}`
            : `${this.documentData?.title}`;
    }

    getTitle(): string {
        if (this.documentType === 'attachments') {
            return `${this.getLabel()} (${this.documentData.typeLabel})`;
        } else if (this.documentType === 'resources') {
            return `${this.getLabel()}`;
        }
    }

    loadContent(): Promise<boolean> {
        this.documentContent = null;
        return new Promise((resolve) => {
            this.subscriptionDocument = this.http
                .get(`../${this.documentData.resourceUrn}`, { responseType: 'blob' })
                .pipe(
                    tap((data: Blob) => {
                        this.documentContent = data;
                    }),
                    finalize(() => {
                        this.loading = false;
                        resolve(true);
                    }),
                    catchError((err: any) => {
                        this.notificationService.handleSoftErrors(err);
                        return of(false);
                    })
                )
                .subscribe();
        });
    }

    getSignatureContent(contentUrl: string): Promise<string | false> {
        return new Promise((resolve) => {
            this.http
                .get(contentUrl, { responseType: 'blob' })
                .pipe(
                    tap(async (res: Blob) => {
                        resolve(await this.functionsService.blobToBase64(res));
                    }),
                    catchError((err: any) => {
                        this.notificationService.handleSoftErrors(err.error.errors);
                        resolve(false);
                        return of(false);
                    })
                )
                .subscribe();
        });
    }

    openDocumentEditor() {
        const dialogRef: MatDialogRef<EditorManagerModalComponent, any> = this.dialog.open(EditorManagerModalComponent, {
            panelClass: 'maarch-full-height-modal',
            disableClose: true,
            width: '99vw',
            maxWidth: '99vw',
            data: {
                resId: this.documentData.resId,
                isAttachment: this.documentData.isAttachment,
            }
        });
        dialogRef.afterClosed().pipe(
            filter((data: any) => !this.functionsService.empty(data)),
            tap((data: any) => {
                if (data === 'fileSaved') {
                    this.initDocToSign();
                }
            }),
        ).subscribe();
    }
}
