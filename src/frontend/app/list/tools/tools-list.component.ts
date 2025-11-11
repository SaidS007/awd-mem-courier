import { Component, Input, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { MatLegacyAutocompleteTrigger as MatAutocompleteTrigger } from '@angular/material/legacy-autocomplete';
import { MatDialog } from '@angular/material/dialog';
import { Observable } from 'rxjs';
import { ExportComponent } from '../export/export.component';
import { SummarySheetComponent } from '../summarySheet/summary-sheet.component';
import { PrintedFolderModalComponent } from '@appRoot/printedFolder/printed-folder-modal.component';
import { of } from 'rxjs'; // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche
import { catchError, filter, tap } from 'rxjs/operators'; // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche
import { FunctionsService } from '@service/functions.service'; // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche
import { NotificationService } from '@service/notification/notification.service'; // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche
import { ConfirmActionComponent } from '@appRoot/actions/confirm-action/confirm-action.component'; // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche


export interface StateGroup {
    letter: string;
    names: any[];
}

@Component({
    selector: 'app-tools-list',
    templateUrl: 'tools-list.component.html',
    styleUrls: ['tools-list.component.scss'],
    standalone: false
})
export class ToolsListComponent {

    @ViewChild(MatAutocompleteTrigger, { static: true }) autocomplete: MatAutocompleteTrigger;

    @Input() listProperties: any;
    @Input() currentBasketInfo: any;

    @Input() selectedRes: any;
    @Input() totalRes: number;

    @Input() from: string;

    @Input() notAllowedResources: number[] = [];

    toolsListButtons: any[] = [
        // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche
        {
            id: 'exportPESV2Resource',
            label: this.translate.instant('lang.exportPESV2Resource'),
            icon: 'fas fa-file-export',
            allowedSources: ['basket', 'search', 'folder'],
            click: () => this.runExportPESV2()
        },
        // END EDISSYUM - NCH01
        {
            id: 'summarySheets',
            label: this.translate.instant('lang.summarySheets'),
            icon: 'fas fa-scroll',
            allowedSources: ['basket', 'search'],
            click: () => this.openSummarySheet(),
        },
        {
            id: 'exportDatas',
            label: this.translate.instant('lang.exportDatas'),
            icon: 'fa fa-file-download',
            allowedSources: ['basket', 'search', 'folder'],
            click: () => this.openExport()
        },
        {
            id: 'printedFolder',
            label: this.translate.instant('lang.printedFolder'),
            icon: 'fa fa-print',
            allowedSources: ['basket', 'search'],
            click: () => this.openPrintedFolderPrompt()
        }
    ];

    priorities: any[] = [];
    categories: any[] = [];
    entitiesList: any[] = [];
    statuses: any[] = [];
    metaSearchInput: string = '';

    stateGroups: StateGroup[] = [];
    stateGroupOptions: Observable<StateGroup[]>;

    isLoading: boolean = false;

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        public dialog: MatDialog,
        private functions: FunctionsService, // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche
        private notify: NotificationService, // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche
    ) { }

    openExport(): void {
        const elementsNotAllowed = this.notAllowedResources.some((id: number) => this.selectedRes.includes(id));
        this.dialog.open(ExportComponent, {
            panelClass: 'maarch-modal',
            width: '800px',
            data: {
                selectedRes: this.selectedRes,
                elementsNotAllowed: elementsNotAllowed
            }
        });
    }

    openSummarySheet(): void {
        this.dialog.open(SummarySheetComponent, {
            panelClass: 'maarch-full-height-modal',
            width: '800px',
            data: {
                selectedRes: this.selectedRes
            }
        });
    }

    openPrintedFolderPrompt() {
        this.dialog.open(
            PrintedFolderModalComponent, {
                panelClass: 'maarch-modal',
                width: '800px',
                data: {
                    resId: this.selectedRes,
                    multiple: this.selectedRes.length > 1
                }
            });
    }

    // EDISSYUM - NCH01 Rajout de l'export PESv2 dans la recherche
    runExportPESV2() {
        const dialogRef = this.dialog.open(ConfirmActionComponent, {
            panelClass: 'maarch-modal',
            disableClose: true,
            width: '500px',
            data: {
                'action' : {
                    'label' : this.translate.instant('lang.exportPESV2Resource'),
                },
                'resIds': this.selectedRes,
                'fromSearch': true,
                'resource': {
                    'chrono': '1 ' + this.translate.instant('lang.elements')
                }
            }
        });

        dialogRef.afterClosed().pipe(
            filter((resIds: any) => !this.functions.empty(resIds)),
            tap(() => {
                this.notify.success(this.translate.instant('lang.exportPESV2Resource') + ' en cours de traitement...');
                this.http.post('../rest/pesv2', { 'resources' : this.selectedRes, 'fromSearch': true }).pipe(
                    tap(() => {
                        this.notify.success(this.translate.instant('lang.exportPESV2Resource') + ' effectué avec succès');
                    }),
                    catchError((err: any) => {
                        this.notify.handleErrors(err);
                        return of(false);
                    })
                ).subscribe();
            }),
            catchError((err: any) => {
                this.notify.handleErrors(err);
                return of(false);
            })
        ).subscribe();
    }
    // END EDISSYUM - NCH01
}
