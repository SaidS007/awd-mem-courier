import { Component, Inject, Input, OnInit } from '@angular/core';
import { FunctionsService } from '@service/functions.service';
import { catchError, finalize, tap } from 'rxjs/operators';
import { of } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';
import { HttpClient } from '@angular/common/http';
import { ScanPipe } from 'ngx-pipes';
import { MAT_DIALOG_DATA, MatDialog } from '@angular/material/dialog';
@Component({
    selector: 'app-lex-persona',
    templateUrl: './lex-persona.component.html',
    styleUrls: ['./lex-persona.component.scss'],
    providers: [ScanPipe],
    standalone: false
})

export class LexPersonaComponent implements OnInit {
    @Input() additionalsInfos: any;
    @Input() externalSignatoryBookDatas: any;
    resId: number = null;
    visaWorkflow: any = {
        roles: ['sign', 'visa'],
        selectedRole: '',
        selectedOrganizationId: '',
        items: []
    };

    sendedInfos: { external_id: any, selectedRole: string, selectedOrganizationId: string, item_mode: string, item_id: number }[] = [];
    visaWorkflowClone: any = [];

    selectedRoles: { [key: number]: string } = {};
    loading: boolean = false;
    hasHistory: boolean = false;

    workflowSignatoryRole: string;
    errorMessage: string = '';
    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        public functions: FunctionsService,
        @Inject(MAT_DIALOG_DATA) public data: any,
        public dialog: MatDialog,
    ) {}
    async ngOnInit() {
        this.resId = this.data['resource']['resId'];
        await this.loadWorkflowWithRoles(this.resId);
    }
    selectRole(index: number, title: string) {
        this.selectedRoles[index] = title;
        this.visaWorkflow.items[index]['selectedRole'] = title;
        this.visaWorkflow.items.forEach((element: any) => {
            element['roles'].forEach((secondElement: any) => {
                if ( secondElement.title === title ) {
                    this.visaWorkflow.items[index]['selectedOrganizationId'] = secondElement['organizationId'];
                }
            });
        });
    }
    getRessources() {
        return this.additionalsInfos.attachments.map((e: any) => e.res_id);
    }
    getDatas() {
        this.sendedInfos.splice(0);
        this.visaWorkflow.items.map(({ external_id, selectedRole, selectedOrganizationId, item_mode, item_id }) => {
            this.sendedInfos.push({ external_id, selectedRole, selectedOrganizationId, item_mode, item_id });
        });
        this.externalSignatoryBookDatas = {
            'lexPersona': this.sendedInfos,
            'actionId': this.data['action']['id'],
            'steps': []
        };
        return this.externalSignatoryBookDatas;
    }
    isValidParaph() {
        return this.visaWorkflow.items.length !== 0;

    }
    getLastVisaUser() {
        const arrOnlyProcess = this.visaWorkflow.items.filter((item: any) => !this.functions.empty(item.process_date) && item.isValid);
        return !this.functions.empty(arrOnlyProcess[arrOnlyProcess.length - 1]) ? arrOnlyProcess[arrOnlyProcess.length - 1] : '';
    }

    getRealIndex(index: number) {
        while (index < this.visaWorkflow.items.length && !this.visaWorkflow.items[index].isValid) {
            index++;
        }
        return index;
    }

    getCurrentVisaUserIndex() {
        if (this.getLastVisaUser().listinstance_id === undefined) {
            const index = 0;
            return this.getRealIndex(index);
        } else {
            let index = this.visaWorkflow.items.map((item: any) => item.listinstance_id).indexOf(this.getLastVisaUser().listinstance_id);
            index++;
            return this.getRealIndex(index);
        }
    }
    loadWorkflowWithRoles(resId: number) {
        this.resId = resId;
        this.loading = true;
        this.visaWorkflow.items = [];
        return new Promise((resolve) => {
            this.http.get(`../rest/lexPersona/getUser/${this.resId}?actionId=${this.data['action']['id']}`).pipe(
                tap((data: any) => {
                    if (!this.functions.empty(data.circuit)) {
                        data.circuit.forEach((element: any) => {
                            this.visaWorkflow.items.push(
                                {
                                    ...element,
                                    difflist_type: 'VISA_CIRCUIT',
                                    currentRole: this.getRole(element)
                                });
                        });
                        this.visaWorkflowClone = JSON.parse(JSON.stringify(this.visaWorkflow.items));
                    }
                    this.hasHistory = data.hasHistory;
                }),
                finalize(() => {
                    this.loading = false;
                    this.visaWorkflow.items.forEach((element: any) => {
                        element['roles'].push({
                            title: 'Aucune fonction',
                            organizationId: 'Aucune fonction'
                        });
                    });
                    resolve(true);
                }),
                catchError((err: any) => {
                    this.errorMessage = err.error.errors;
                    return of(false);
                })
            ).subscribe();
        });
    }
    stringIncludes(source: any, search: any) {
        if (source === undefined || source === null) {
            return false;
        }
        return source.includes(search);
    }
    getRole(item: any) {
        if (this.functions.empty(item.process_date)) {
            return item.requested_signature ? 'sign' : 'visa';
        } else {
            if (this.stringIncludes(item.process_comment, this.translate.instant('lang.visaWorkflowInterrupted'))) {
                return item.requested_signature ? 'sign' : 'visa';
            } else {
                return item.signatory ? 'sign' : 'visa';
            }
        }
    }
}
