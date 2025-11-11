import { Component, OnInit, ViewChild, ViewContainerRef } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { AppService } from '@service/app.service';
import { environment } from '../environments/environment';
import { HttpClient } from '@angular/common/http';
import { MatDialogRef } from '@angular/material/dialog';
import { MatIconRegistry } from '@angular/material/icon';
import { DomSanitizer } from '@angular/platform-browser';
import { PluginManagerService } from "@service/plugin-manager.service";
import { catchError, of, tap } from "rxjs";
import { DatePipe } from "@angular/common";
import { filter } from "rxjs/operators";

@Component({
    templateUrl: 'about-us.component.html',
    styleUrls: ['about-us.component.css'],
    standalone: false
})
export class AboutUsComponent implements OnInit {

    @ViewChild('myPlugin', { read: ViewContainerRef, static: true }) myPlugin: ViewContainerRef;

    applicationVersion: string;
    applicationDesc: string;
    currentYear: number;

    plugins: any[] = [];

    loading: boolean = false;

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        public appService: AppService,
        private pluginManagerService: PluginManagerService,
        public dialogRef: MatDialogRef<AboutUsComponent>,
        private translateService: TranslateService,
        private datePipe: DatePipe,
        iconReg: MatIconRegistry,
        sanitizer: DomSanitizer,
    ) {
        iconReg.addSvgIcon('maarchBox', sanitizer.bypassSecurityTrustResourceUrl('assets/maarch_box.svg'));
    }

    async ngOnInit() {
        this.applicationVersion = environment.VERSION;
        this.applicationDesc = environment.APP_DESC;
        this.currentYear = new Date().getFullYear();
        this.getMaarchParapheurApiInfo();
        await this.getPluginsInfo();
        this.loading = false;
    }

    getMaarchParapheurApiInfo(): void {
        this.http.get('../rest/signatureBook/version').pipe(
            filter((res: any) => res),
            tap((res: any) => {
                this.plugins.push({
                    name: 'maarch-parapheur-api',
                    version: res.version ? res.version : this.translateService.instant('lang.undefined'),
                    build: res.time ? `(BUILD ${this.datePipe.transform(res.time, 'dd-MM-yyyy HH:mm')})` : ''
                })
            }),
            catchError(() => {
                return of(false);
            })
        ).subscribe();
    }

    async getPluginsInfo(): Promise<void> {
        for (let i: number = 0; i < Object.keys(this.pluginManagerService.plugins).length; i++) {
            const pluginName: string = Object.keys(this.pluginManagerService.plugins)[i];
            const res: { description: string; version: string } | false = await this.pluginManagerService.showPluginVersion(
                pluginName,
                this.myPlugin
            );
            this.plugins.push({
                name: Object.keys(this.pluginManagerService.plugins)[i],
                version: res ? res.version : this.translateService.instant('lang.undefined'),
                build: res ? res.description : ''
            })
        }
        this.myPlugin.detach();
    }
}

