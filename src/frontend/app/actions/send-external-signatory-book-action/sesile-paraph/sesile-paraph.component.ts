import {Component, Inject, Input, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA} from "@angular/material/dialog";
import { HttpClient } from '@angular/common/http';
import {catchError, finalize, tap} from "rxjs/operators";
import {of} from "rxjs";
import { NotificationService } from '@service/notification/notification.service';
import { UntypedFormControl } from '@angular/forms';

@Component({
    selector: 'app-sesile-paraph',
    templateUrl: './sesile-paraph.component.html',
    styleUrls: ['./sesile-paraph.component.scss'],
    standalone: false
})
export class SesileParaphComponent implements OnInit {
    @Input() additionalsInfos: any;
    @Input() externalSignatoryBookDatas: any;
    sesileDatas: any;
    circuits: any[] = [];
    typesClasseur: any[] = [];
    loading: boolean = true;

    selectedFormData : any = { idSelectedCircuit: '', nameSelectedCircuit: '', idSelectedTypeClasseur: '', nameSelectedTypeClasseur: '' };
    selectDataControl: UntypedFormControl = new UntypedFormControl();
    selectDataControl2: UntypedFormControl = new UntypedFormControl();
    constructor(
        public http: HttpClient,
        @Inject(MAT_DIALOG_DATA) public data: any,
        private notifications: NotificationService
    ) { }

    ngOnInit(): void {
        this.loadData();
        this.loading = false;
    }

    circuitSelected(optionId: number) {
        this.typesClasseur = [];
        this.sesileDatas.forEach((element: any) => {
            if( element.id === optionId ) {
                this.selectedFormData.nameSelectedCircuit = element.nom;
                element.typesCompleted.forEach((item: any) => {
                    this.typesClasseur.push({id: item.id, label: item.name});
                })
            }
        });
        this.selectedFormData.idSelectedCircuit = optionId;
    }
    typeClasseurSelected(optionId: number) {
        this.selectedFormData.idSelectedTypeClasseur = optionId
        this.typesClasseur.forEach((element :any) => {
            if (element.id === optionId) {
                this.selectedFormData.nameSelectedTypeClasseur = element.label;
            }
        });
    }
    getRessources() {
        return this.additionalsInfos.attachments.map((e: any) => e.res_id);
    }
    isValidParaph() {
        return true;
    }
    getDatas() {
        this.externalSignatoryBookDatas = {
            'sesile': '',
            'selectedFormData': this.selectedFormData,
            'steps': []
        };
        return this.externalSignatoryBookDatas;
    }

    loadData() {
        this.http.get(`../rest/sesile/getDatas`).pipe(
            tap((data: any) => {
                this.sesileDatas = data.Data;
                this.sesileDatas.forEach((element: any) => {
                    this.circuits.push({id: element.id, label: element.nom});
                });
            }),
            catchError((err: any) => {
                this.notifications.handleSoftErrors(err);
                return of(false);
            })
        ).subscribe();
    }
}
