import { Component, Inject } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
    templateUrl: 'view-doc-action.component.html',
    styleUrls: ['view-doc-action.component.scss'],
    standalone: false
})
export class ViewDocActionComponent {

    constructor(
        public translate: TranslateService,
        @Inject(MAT_DIALOG_DATA) public data: any
    ) { }
}
