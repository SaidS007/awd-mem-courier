import { Component, OnInit, Inject, ViewChild } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { NotificationService } from '@service/notification/notification.service';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { NoteEditorComponent } from '../../notes/note-editor.component';
import { tap, finalize, catchError } from 'rxjs/operators';
import { of } from 'rxjs';
import { VisaWorkflowComponent } from '../../visa/visa-workflow.component';
import { FunctionsService } from '@service/functions.service';

@Component({
    templateUrl: 'reject-visa-back-to-previous-action.component.html',
    styleUrls: ['reject-visa-back-to-previous-action.component.scss'],
    standalone: false
})
export class RejectVisaBackToPrevousActionComponent implements OnInit {

    @ViewChild('noteEditor', { static: true }) noteEditor: NoteEditorComponent;
    @ViewChild('appVisaWorkflow', { static: false }) appVisaWorkflow: VisaWorkflowComponent;

    loading: boolean = false;

    resourcesWarnings: any[] = [];
    resourcesErrors: any[] = [];

    noResourceToProcess: boolean = null;

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        private notify: NotificationService,
        public dialogRef: MatDialogRef<RejectVisaBackToPrevousActionComponent>,
        @Inject(MAT_DIALOG_DATA) public data: any,
        public functions: FunctionsService
    ) { }

    async ngOnInit() {
        this.loading = true;
        await this.checkRejectVisaBackToPrevious();
        this.loading = false;
    }

    checkRejectVisaBackToPrevious() {
        this.resourcesErrors = [];
        this.resourcesWarnings = [];

        return new Promise((resolve) => {
            this.http.post('../rest/resourcesList/users/' + this.data.userId + '/groups/' + this.data.groupId + '/baskets/' + this.data.basketId + '/actions/' + this.data.action.id + '/checkRejectVisa', { resources: this.data.resIds })
                .subscribe((data: any) => {
                    if (!this.functions.empty(data.resourcesInformations.warning)) {
                        this.resourcesWarnings = data.resourcesInformations.warning;
                    }

                    if (!this.functions.empty(data.resourcesInformations.error)) {
                        this.resourcesErrors = data.resourcesInformations.error;
                        this.noResourceToProcess = this.resourcesErrors.length === this.data.resIds.length;
                    }
                    resolve(true);
                }, (err: any) => {
                    this.notify.handleSoftErrors(err);
                    this.dialogRef.close();
                });
        });
    }

    onSubmit() {
        this.loading = true;
        this.executeAction();
    }

    executeAction() {
        // EDISSYUM - AMI01 Ajout de la notion d'annotation [VISA]
        if (this.noteEditor.getNoteContent() != null && this.noteEditor.getNoteContent().length > 0) {
            const noteContent: string = `[${this.translate.instant('lang.visa').toUpperCase()}] ${this.noteEditor.getNoteContent()}`;
            this.noteEditor.setNoteContent(noteContent);
        }
        //END EDISSYUM - AMI01

        const realResSelected: number[] = this.data.resIds.filter(
            (resId: number) => this.resourcesErrors.map((resErr) => resErr.res_id).indexOf(resId) === -1
        );
        this.http.put(this.data.processActionRoute, { resources : realResSelected, note : this.noteEditor.getNote() }).pipe(
            tap(() => {
                this.dialogRef.close(this.data.resIds);
            }),
            finalize(() => this.loading = false),
            catchError((err: any) => {
                this.notify.handleSoftErrors(err);
                return of(false);
            })
        ).subscribe();
    }

    isValidAction() {
        return !this.noResourceToProcess;
    }
}
