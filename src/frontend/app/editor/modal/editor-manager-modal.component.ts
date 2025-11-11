import { Component, Inject, ViewChild } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import {
    MAT_DIALOG_DATA,
    MatDialog,
    MatDialogRef
} from '@angular/material/dialog';
import { EditorManagerComponent } from '../editor-manager.component';

@Component({
    templateUrl: 'editor-manager-modal.component.html',
    styleUrls: ['editor-manager-modal.component.scss'],
    standalone: false
})
export class EditorManagerModalComponent {

    @ViewChild('editorManager', { static: false }) editorManager: EditorManagerComponent;

    title: string = '';

    constructor(
        public translate: TranslateService,
        public dialog: MatDialog,
        public dialogRef: MatDialogRef<EditorManagerModalComponent>,
        @Inject(MAT_DIALOG_DATA) public data: any
    ) { }

    closeModal(id: string) {
        this.dialogRef.close(id);
    }
}
