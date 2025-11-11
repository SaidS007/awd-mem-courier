import {Component, ViewChild, HostListener, AfterViewInit, inject} from '@angular/core';
import { MAT_LEGACY_TOOLTIP_DEFAULT_OPTIONS as MAT_TOOLTIP_DEFAULT_OPTIONS, MatLegacyTooltipDefaultOptions as MatTooltipDefaultOptions } from '@angular/material/legacy-tooltip';
import { HeaderService } from '@service/header.service';
import { AppService } from '@service/app.service';
import { MatSidenav } from '@angular/material/sidenav';
import { HttpClient } from '@angular/common/http';
import { AuthService } from '@service/auth.service';
import { TranslateService } from '@ngx-translate/core';
import { MatDialog } from '@angular/material/dialog';
import { tap } from 'rxjs';
import { SereniaChatbotService } from "@plugins/serenia-chatbot/serenia-chatbot-service.component";

/** Custom options the configure the tooltip's default show/hide delays. */
export const myCustomTooltipDefaults: MatTooltipDefaultOptions = {
    showDelay: 500,
    hideDelay: 0,
    touchendHideDelay: 0,
};

@Component({
    selector: 'app-root',
    templateUrl: 'app.component.html',
    providers: [
        { provide: MAT_TOOLTIP_DEFAULT_OPTIONS, useValue: myCustomTooltipDefaults }
    ],
    standalone: false
})
export class AppComponent implements AfterViewInit {

    @ViewChild('snavLeft', { static: false }) snavLeft: MatSidenav;
    @ViewChild('snavRight', { static: false }) snavRight: MatSidenav;

    debugMode: boolean = false;
    loading: boolean = true;
    public sereniaService = inject(SereniaChatbotService); // EDISSYUM - NCH01 Implémentation SerenIA

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        public appService: AppService,
        public headerService: HeaderService,
        public authService: AuthService,
        public dialog: MatDialog
    ) {
        this.appService.loadAppCore();
        this.appService.catchEvent().pipe(
            tap(() => {
                setTimeout(() => {
                    this.headerService.sideNavLeft = this.snavLeft;
                    this.headerService.sideNavRight = this.snavRight;
                    this.loading = false;
                }, 0);
            })
        ).subscribe();
    }

    @HostListener('window:resize', ['$event'])
    onResize() {
        this.appService.setScreenWidth(window.innerWidth);
    }

    ngAfterViewInit(): void {
        // EDISSYUM - NCH01 Implémentation SerenIA
        this.http.get('../rest/serenia/enabled').pipe(
            tap((data: any) => {
                if (data && data.serenia_enabled) {
                    this.sereniaService.enable = data.serenia_enabled;
                }
            })
        ).subscribe();
        // END EDISSYUM - NCH01
        this.appService.setScreenWidth(window.innerWidth);
    }

    // EDISSYUM - NCH01 Implémentation SerenIA
    @HostListener('document:click', ['$event'])
    onScreenClick(event: MouseEvent) {
        const clickedElement = event.target as HTMLElement;
        const sereniaElements = document.querySelectorAll('[class^="serenia_"]');

        let showDialog = false;
        sereniaElements.forEach((element) => {
            if (element.contains(clickedElement)) {
                showDialog = true;
            }
        });

        setTimeout(() => {
            this.sereniaService.showDialog = showDialog;
        }, 200)
    }
    // END EDISSYUM - NCH01
}
