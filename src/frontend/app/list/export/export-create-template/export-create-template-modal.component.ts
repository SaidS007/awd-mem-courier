import { Component, Inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { NotificationService } from '@service/notification/notification.service';
import { tap, catchError } from 'rxjs/operators';
import { of } from 'rxjs';
import { DatePipe } from '@angular/common';
import { FunctionsService } from '@service/functions.service';
import { HeaderService } from '@service/header.service';

@Component({
    templateUrl: 'export-create-template-modal.component.html',
    styleUrls: ['export-create-template-modal.component.scss'],
    standalone: false
})
export class AddExportCreateTemplateModalComponent {

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        @Inject(MAT_DIALOG_DATA) public data: any,
        public dialogRef: MatDialogRef<AddExportCreateTemplateModalComponent>,
        private notify: NotificationService,
        private datePipe: DatePipe,
        public headerService: HeaderService,
        public functions: FunctionsService) {
    }
    
    onSubmit() {
        
        Object.keys(this.data.exportTemplate).map((data: any) => {
            this.data.exportTemplate['creation_date'] = this.datePipe.transform(Date.now(), 'y-MM-dd');
            this.data.exportTemplate['user_id'] = this.headerService.user.id;
        });
        
        this.http.post('../rest/resourcesList/exports/models', this.data.exportTemplate).pipe(
            tap((data: any) => {
                this.notify.success(this.translate.instant('lang.exportTemplateAdded'));
                this.dialogRef.close(this.data);
            }),
            catchError((err: any) => {
                this.notify.handleErrors(err);
                return of(false);
            })
        ).subscribe();
    }
}
