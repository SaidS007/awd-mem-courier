import { Component, OnInit, Inject, HostListener } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { HttpClient } from '@angular/common/http';
import { map, tap, catchError, exhaustMap, finalize } from 'rxjs/operators';
import { NotificationService } from '@service/notification/notification.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { FunctionsService } from '@service/functions.service';
import { of } from 'rxjs';

declare let $: any;

@Component({
    templateUrl: 'export-share-template.component.html',
    styleUrls: ['export-share-template.component.scss'],
    standalone: false
})
export class ExportShareTemplateComponent implements OnInit {

    export: any = {
        id: 0,
        label: '',
        public: true,
        user_id: 0,
        parent_id: null,
        level: 0,
        sharing: {
            entities: []
        }
    };

    sharingExportCLone: any[] = [];

    holdShift: boolean = false;

    entities: any[] = [];

    exportModel: any = {};

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        private notify: NotificationService,
        public dialogRef: MatDialogRef<ExportShareTemplateComponent>,
        public functions: FunctionsService,
        @Inject(MAT_DIALOG_DATA) public data: any
    ) { }

    @HostListener('document:keydown.Shift', ['$event']) onKeydownHandler(event: KeyboardEvent) {
        this.holdShift = true;
    }
    @HostListener('document:keyup', ['$event']) onKeyupHandler(event: KeyboardEvent) {
        this.holdShift = false;
    }

    ngOnInit(): void {
        this.getModelTemplate();
        this.getEntities();
        this.exportModel = this.data.exportTemplate;
    }

    getEntities() {
        this.http.get('../rest/entities').pipe(
            map((data: any) => {
                const keywordEntities = {
                    serialId: 'ALL_ENTITIES',
                    keyword: 'ALL_ENTITIES',
                    parent: '#',
                    icon: 'fa fa-hashtag',
                    allowed: true,
                    text: this.translate.instant('lang.allEntities'),
                    state: { 'opened': false, 'selected': false },
                    parent_entity_id: '',
                    id: 'ALL_ENTITIES',
                    entity_label: this.translate.instant('lang.allEntities')
                };

                data.entities.unshift(keywordEntities);
                this.entities = data.entities;

                data.entities.forEach((element: any) => {
                    this.data.exportTemplate.entity_id.forEach((elem: any) => {
                        if (!this.functions.empty(element.serialId) && !this.functions.empty(elem.entity_id)) {
                            if (element.serialId === elem.entity_id) {
                                element.state.selected = true;
                                if (!this.functions.empty(element.keyword)) {
                                    this.export.sharing.entities.push(
                                        {
                                            keyword: element.keyword,
                                            edition: elem.edition
                                        }
                                    );
                                } else {
                                    this.export.sharing.entities.push(
                                        {
                                            entity_id: element.serialId,
                                            edition: elem.edition
                                        }
                                    );
                                }
                            }
                        }

                        if (!this.functions.empty(element.keyword) && !this.functions.empty(elem.keyword)) {
                            if (element.keyword === elem.keyword) {
                                element.state.selected = true;
                                if (!this.functions.empty(element.keyword)) {
                                    this.export.sharing.entities.push(
                                        {
                                            keyword: element.keyword,
                                            edition: elem.edition
                                        }
                                    );
                                } else {
                                    this.export.sharing.entities.push(
                                        {
                                            entity_id: element.serialId,
                                            edition: elem.edition
                                        }
                                    );
                                }
                            }
                        }
                    });
                    element.state.allowed = true;
                    element.state.disabled = false;
                });

                return data;
            }),
            tap((data: any) => {
                this.initEntitiesTree(data.entities);
            }),
            catchError((err: any) => {
                this.notify.handleErrors(err);
                return of(false);
            }),
            finalize(() => this.sharingExportCLone = JSON.parse(JSON.stringify(this.export.sharing.entities)))
        ).subscribe();
    }

    initExportsTree(exports: any) {
        $('#jstreeExports').jstree({
            'checkbox': {
                'deselect_all': true,
                'three_state': false // no cascade selection
            },
            'core': {
                force_text: true,
                'themes': {
                    'name': 'proton',
                    'responsive': true
                },
                'multiple': false,
                'data': exports
            },
            'plugins': ['checkbox', 'search']
        });
        $('#jstreeExports')
            // listen for event
            .on('select_node.jstree', (e: any, data: any) => {
                this.export.parent_id = data.node.original.id;

            }).on('deselect_node.jstree', (e: any, data: any) => {
                this.export.parent_id = '';
            })
            // create the instance
            .jstree();
        let to: any = false;
        $('#jstree_searchExports').keyup(function () {
            if (to) {
                clearTimeout(to);
            }
            to = setTimeout(function () {
                const v: any = $('#jstree_searchExports').val();
                $('#jstreeExports').jstree(true).search(v);
            }, 250);
        });
    }

    initEntitiesTree(entities: any) {
        $('#jstree').jstree({
            'checkbox': {
                'three_state': false // no cascade selection
            },
            'core': {
                force_text: true,
                'themes': {
                    'name': 'proton',
                    'responsive': true
                },
                'data': entities
            },
            'plugins': ['checkbox', 'search']
        });
        $('#jstree')
            // listen for event
            .on('select_node.jstree', (e: any, data: any) => {
                this.selectEntity(data.node.original);

            }).on('deselect_node.jstree', (e: any, data: any) => {
                this.deselectEntity(data.node.original);
            })
            // create the instance
            .jstree();
        let to: any = false;
        $('#jstree_search').keyup(function () {
            if (to) {
                clearTimeout(to);
            }
            to = setTimeout(function () {
                const v: any = $('#jstree_search').val();
                $('#jstree').jstree(true).search(v);
            }, 250);
        });
    }

    selectEntity(newEntity: any) {
        if (this.holdShift) {
            $('#jstree').jstree('deselect_all');
            this.export.sharing.entities = [];
        } else {
            if (!this.functions.empty(newEntity.keyword)) {
                this.export.sharing.entities.push(
                    {
                        keyword: newEntity.keyword,
                        edition: false
                    }
                );
            } else {
                this.export.sharing.entities.push(
                    {
                        entity_id: newEntity.serialId,
                        edition: false
                    }
                );
            }
        }
    }

    deselectEntity(entity: any) {
        let index = this.export.sharing.entities.map((data: any) => data.entity_id).indexOf(entity.serialId);
        if (index > -1) {
            this.export.sharing.entities.splice(index, 1);
        } else {
            index = this.export.sharing.entities.map((data: any) => data.keyword).indexOf(entity.serialId);
            if (index > -1) {
                this.export.sharing.entities.splice(index, 1);
            }
        }
    }

    onSubmit(): void {
        this.http.put('../rest/resourcesList/exportModelsEntity/' + this.data.exportTemplate.id, { 'entity_id': this.export.sharing.entities }).pipe(
            tap((data: any) => {
                this.notify.success(this.translate.instant('lang.exportUpdated'));
                this.dialogRef.close('success');
            }),
            catchError((err: any) => {
                this.notify.handleBlobErrors(err);
                return of(false);
            })
        ).subscribe();
    }

    checkSelectedExport(entity: any) {
        if (this.export.sharing.entities.map((data: any) => data.entity_id).indexOf(entity.serialId) > -1
            || this.export.sharing.entities.map((data: any) => data.keyword).indexOf(entity.serialId) > -1) {
            return true;
        } else {
            return false;
        }
    }

    initService(ev: any) {
        if (ev.index === 1) {
            this.initEntitiesTree(this.entities);
        }
    }

    toggleAdmin(entity: any, ev: any) {
        let index = this.export.sharing.entities.map((data: any) => data.entity_id).indexOf(entity.serialId);
        if (index > -1) {
            this.export.sharing.entities[index].edition = ev.checked;
        } else {
            index = this.export.sharing.entities.map((data: any) => data.keyword).indexOf(entity.serialId);
            if (index > -1) {
                this.export.sharing.entities[index].edition = ev.checked;
            }
        }
    }

    isAdminEnabled(entity: any) {
        let index = this.export.sharing.entities.map((data: any) => data.entity_id).indexOf(entity.serialId);
        if (index > -1) {
            return this.export.sharing.entities[index].edition;
        } else {
            index = this.export.sharing.entities.map((data: any) => data.keyword).indexOf(entity.serialId);
            if (index > -1) {
                return this.export.sharing.entities[index].edition;
            }
        }
        return false;
    }

    getModelTemplate() {
        this.http.get('../rest/resourcesList/exportModels/' + this.data.exportTemplate.id).pipe(
            tap((data: any) => {
                this.data.exportTemplate.entity_id = data.template[0].entity_id;
            }),
            catchError((err: any) => {
                this.notify.handleErrors(err);
                return of(false);
            })
        ).subscribe();
    }
}
