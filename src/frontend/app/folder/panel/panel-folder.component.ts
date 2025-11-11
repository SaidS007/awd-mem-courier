import { Component, OnInit, Input, ViewChild, Output, EventEmitter, OnDestroy } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { FolderTreeComponent } from '../folder-tree.component';
import { FoldersService } from '../folders.service';
import { ActionsService } from '../../actions/actions.service';
import { Subscription } from 'rxjs';
import { HttpClient } from '@angular/common/http';  // EDISSYUM - EME01  Ajout d'une fenêtre pour administrer la recherche des dossiers

@Component({
    selector: 'app-panel-folder',
    templateUrl: 'panel-folder.component.html',
    styleUrls: ['panel-folder.component.scss'],
    standalone: false
})
export class PanelFolderComponent implements OnInit, OnDestroy {

    @Input() selectedId: number;

    @ViewChild('folderTree', { static: false }) folderTree: FolderTreeComponent;

    @Output() refreshEvent = new EventEmitter<string>();

    subscription: Subscription;

    // EDISSYUM - EME01  Ajout d'une fenêtre pour administrer la recherche des dossiers
    expandedParameter: number;
    expandedFoldersByDefault: boolean = false;
    // END EDISSYUM - EME01

    constructor(
        public translate: TranslateService,
        public foldersService: FoldersService,
        public actionService: ActionsService,
        public http: HttpClient // EDISSYUM - EME01  Ajout d'une fenêtre pour administrer la recherche des dossiers
    ) {
        this.subscription = this.actionService.catchAction().subscribe(() => {

            this.refreshFoldersTree();
        });
    }

    ngOnInit(): void {
        this.foldersService.getPinnedFolders();

        // EDISSYUM - EME01  Ajout d'une fenêtre pour administrer la recherche des dossiers
        setTimeout(() => {
            this.http.get('../rest/parameters/showFoldersByDefault')
                .subscribe((data: any) => {
                    this.expandedParameter = data.parameter.param_value_int;
                    this.expandedFoldersByDefault = this.expandedParameter === 1;
                });
        }, 500);
        // END EDISSYUM - EME01
    }

    ngOnDestroy() {
        // unsubscribe to ensure no memory leaks
        this.subscription.unsubscribe();
    }

    initTree() {
        this.folderTree.openTree(this.selectedId);
    }

    refreshDocList() {
        this.refreshEvent.emit();
    }

    refreshFoldersTree() {
        if (this.folderTree !== undefined) {
            this.folderTree.getFolders();
        }
    }
}
