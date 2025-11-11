import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { NotificationService } from '@service/notification/notification.service';
import { HeaderService } from '@service/header.service';
import { AppService } from '@service/app.service';
import { tap } from 'rxjs/operators';
import {PrivilegeService} from "@service/privileges.service";

@Component({
    templateUrl: 'update-status-administration.component.html',
    styleUrls: ['update-status-administration.component.css'],
    standalone: false
})
export class UpdateStatusAdministrationComponent implements OnInit {


    loading: boolean = false;

    statuses: any[] = [];
    statusId: string = '';
    resId: string = '';
    chrono: string = '';
    resIdList: string[] = [];
    chronoList: string[] = [];
    allowedStatuses: any[] = [];

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        private notify: NotificationService,
        private headerService: HeaderService,
        public appService: AppService,
        private privilegeService: PrivilegeService
    ) { }

    async ngOnInit(): Promise<void> {
        this.headerService.setHeader(this.translate.instant('lang.updateStatus'));

        this.loading = true;

        this.http.get('../rest/autocomplete/statuses').pipe(
            tap(async (data: any) => {
                if (this.headerService.user.mode === 'standard') {
                    for (const group of this.headerService.user.groups) {
                        let allowedStatuses: Object;
                        allowedStatuses = await this.getAllowedStatuses(group);
                        if (allowedStatuses === null || allowedStatuses === undefined) {
                            continue;
                        }
                        this.allowedStatuses = this.allowedStatuses.concat(allowedStatuses);
                    }

                    this.allowedStatuses = [...new Set(this.allowedStatuses)];
                    this.statuses = data.filter(status => {
                        return this.allowedStatuses.some(allowedStatus => {
                            return allowedStatus === status.id;
                        });
                    });
                } else {
                    this.statuses = data;
                }
            }),
            tap(() => this.loading = false)
        ).subscribe();
    }

    async getAllowedStatuses(group: any) {
        return await this.http.get(`../rest/groups/${group.id}/privileges/update_status_mail/parameters?parameter=status`).toPromise();
    }

    onSubmit() {
        const body = {
            'status': this.statusId
        };
        if (this.resIdList.length > 0) {
            body['resId'] = this.resIdList;
        } else if (this.chronoList.length > 0) {
            body['chrono'] = this.chronoList;
        }

        this.http.put('../rest/res/resource/status?admin=true', body)
            .subscribe(() => {
                this.resId = '';
                this.chrono = '';
                this.statusId = '';
                this.resIdList = [];
                this.chronoList = [];
                this.notify.success(this.translate.instant('lang.modificationSaved'));
            }, (err: any) => {
                this.notify.error(err.error.errors);
            });
    }

    addResId(): void {
        if (this.resIdList.indexOf(this.resId) === -1) {
            this.resIdList.push(this.resId);
        }
        this.resId = '';
    }

    addChrono(): void {
        if (this.chronoList.indexOf(this.chrono) === -1) {
            this.chronoList.push(this.chrono);
        }
        this.chrono = '';
    }

    setStatus(status: any) {
        this.statusId = status.id;
    }

    removeResId(resId: string): void {
        const resIdIndex = this.resIdList.indexOf(resId);
        this.resIdList.splice(resIdIndex, 1);
    }

    removeChrono(chrono: string): void {
        const chronoIndex = this.chronoList.indexOf(chrono);
        this.chronoList.splice(chronoIndex, 1);
    }

    resetInput(e: any) {
        if (e.index === 0) {
            this.resId = '';
        } else {
            this.chrono = '';
        }
    }
}
