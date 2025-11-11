import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Validators, UntypedFormGroup, FormControl } from '@angular/forms';
import { tap, catchError } from 'rxjs/operators';
import { AuthService } from '@service/auth.service';
import { NotificationService } from '@service/notification/notification.service';
import { environment } from '../../environments/environment';
import { lastValueFrom, of } from 'rxjs';
import { HeaderService } from '@service/header.service';
import { FunctionsService } from '@service/functions.service';
import { TimeLimitPipe } from '../../plugins/timeLimit.pipe';
import { TranslateService } from '@ngx-translate/core';
import { LocalStorageService } from '@service/local-storage.service';
import { SignatureBookService } from "@appRoot/signatureBook/signature-book.service";

@Component({
    templateUrl: 'login.component.html',
    styleUrls: ['login.component.scss'],
    providers: [TimeLimitPipe],
    standalone: false
})
export class LoginComponent implements OnInit {
    loginForm: UntypedFormGroup;

    loading: boolean = false;
    showForm: boolean = true;
    environment: any;
    applicationName: string = '';
    loginMessage: string = '';
    hidePassword: boolean = true;

    constructor(
        public translate: TranslateService,
        private http: HttpClient,
        public router: Router,
        private headerService: HeaderService,
        public authService: AuthService,
        private localStorage: LocalStorageService,
        private functionsService: FunctionsService,
        private notify: NotificationService,
        public dialog: MatDialog,
        private timeLimit: TimeLimitPipe,
        private signatureBookService: SignatureBookService

    ) {
        this.loginForm = new UntypedFormGroup({
            login: new FormControl(null, Validators.required),
            password: new FormControl(null, Validators.required)
        });
    }

    async ngOnInit(): Promise<void> {

        this.headerService.hideSideBar = true;

        this.environment = environment;
        this.initConnection();
    }

    onSubmit(ssoToken = null) {
        this.loading = true;

        let url = '../rest/authenticate';

        if (ssoToken !== null) {
            url += ssoToken;
        }

        this.http.post(
            url,
            {
                'login': this.loginForm.get('login').value,
                'password': this.loginForm.get('password').value,
            },
            {
                observe: 'response'
            }
        ).pipe(
            tap(async (data: any) => {
                this.localStorage.resetLocal();
                this.authService.saveTokens(data.headers.get('Token'), data.headers.get('Refresh-Token'));
                await lastValueFrom(this.authService.getCurrentUserInfo());
                await this.signatureBookService.getInternalSignatureBookConfig();

                // EDISSYUM - NCH01 Ajout d'une méthode de connexion OIDC | Permet de clean l'url si utilisation de l'OIDC
                if (this.authService.authMode === 'oidc') {
                    if (this.authService.maarchUrl) {
                        const distPresent = window.location.href.includes('/dist/');
                        let url = this.authService.maarchUrl + (distPresent ? '/dist/' : '/');
                        url = url.replace(/([^:]\/)\/+/g, "$1");
                        window.history.replaceState({}, document.title, url);
                    }
                }
                // END - EDISSYUM - NCH01

                if (this.authService.getCachedUrl()) {
                    this.router.navigateByUrl(this.authService.getCachedUrl());
                    this.authService.cleanCachedUrl();
                } else if (!this.functionsService.empty(this.authService.getToken()?.split('.')[1]) && !this.functionsService.empty(this.authService.getUrl(JSON.parse(atob(data.headers.get('Token').split('.')[1])).user.id))) {
                    this.router.navigate([this.authService.getUrl(JSON.parse(atob(data.headers.get('Token').split('.')[1])).user.id)]);
                } else {
                    this.router.navigate(['/home']);
                }
            }),
            catchError((err: any) => {
                this.loading = false;
                if (err.error.errors === 'Authentication Failed') {
                    this.notify.error(this.translate.instant('lang.wrongLoginPassword'));
                } else if (err.error.errors === 'Account Locked') {
                    this.notify.error(this.translate.instant('lang.accountLocked') + ' ' + this.timeLimit.transform(err.error.date));
                } else if (this.authService.authMode === 'sso' && err.error.errors === 'Authentication Failed : login not present in header' && !this.functionsService.empty(this.authService.authUri)) {
                    window.location.href = this.authService.authUri;
                } else if (this.authService.authMode === 'azure_saml' && err.error.errors === 'Authentication Failed : not logged') {
                    window.location.href = err.error.authUri;
                } else {
                    this.notify.handleSoftErrors(err);
                }
                // EDISSYUM - NCH01 Ajout d'une méthode de connexion OIDC | Permet de clean l'url si utilisation de l'OIDC
                if (this.authService.authMode === 'oidc') {
                    if (this.authService.maarchUrl) {
                        const distPresent = window.location.href.includes('/dist/');
                        let url = this.authService.maarchUrl + (distPresent ? '/dist/' : '/');
                        url = url.replace(/([^:]\/)\/+/g, "$1");
                        window.history.replaceState({}, document.title, url + 'index.html');
                    }
                }
                // END - EDISSYUM - NCH01
                return of(false);
            })
        ).subscribe();
    }

    initConnection(force_oidc: boolean = false) { // EDISSYUM - NCH01 Ajout d'une méthode de connexion OIDC | Ajout du paramètre force_oidc
        if (['sso', 'azure_saml'].indexOf(this.authService.authMode) > -1) {
            this.loginForm.disable();
            this.loginForm.setValidators(null);
            this.onSubmit();
        } else if (['cas', 'keycloak'].indexOf(this.authService.authMode) > -1) {
            this.loginForm.disable();
            this.loginForm.setValidators(null);
            const regexCas = /ticket=[.]*/g;
            const regexKeycloak = /code=[.]*/g;
            if (window.location.search.match(regexCas) !== null || window.location.search.match(regexKeycloak) !== null) {
                const ssoToken = window.location.search.substring(1, window.location.search.length);

                const regexKeycloakState = /state=[.]*/g;
                if (ssoToken.match(regexKeycloakState) !== null) {
                    const params = new URLSearchParams(window.location.search.substring(1));
                    const keycloakState = this.localStorage.get('keycloakState');
                    const paramState = params.get('state');

                    this.localStorage.save('keycloakState', null);

                    if (keycloakState !== paramState && keycloakState !== null) {
                        window.location.href = this.authService.authUri;
                        return;
                    }
                }

                window.history.replaceState({}, document.title, window.location.pathname + window.location.hash);
                this.onSubmit(`?${ssoToken}`);
            } else {
                window.location.href = this.authService.authUri;
            }
        }
        // EDISSYUM - NCH01 Ajout d'une méthode de connexion OIDC
        else if (this.authService.authMode === 'oidc') {
            this.loginForm.disable();
            this.loginForm.setValidators(null);
            const regexCode = /code=[.]*/g;
            const regexState = /state=[.]*/g;
            if (window.location.search.match(regexCode) !== null && window.location.search.match(regexState) !== null) {
                const urlParams = new URLSearchParams(window.location.search.substring(1));
                const code = urlParams.get('code');
                const state = urlParams.get('state');
                const nonce = localStorage.getItem('authNonce');
                const ssoToken = `?code=${code}&state=${state}&nonce=${nonce}`;
                localStorage.removeItem('authNonce');
                this.onSubmit(ssoToken);
            } else {
                if (!window.location.href.includes('stopOidc=true') || force_oidc) {
                    if (force_oidc) {
                        localStorage.removeItem('authNonce');
                    }
                    const nonce = /nonce=[.]*/g;
                    const urlParams = new URLSearchParams(this.authService.authUri.substring(1));
                    if (this.authService.authUri.search(nonce) !== null) {
                        const authNonce = localStorage.getItem('authNonce');
                        if (authNonce === null || authNonce === 'null') {
                            localStorage.setItem('authNonce', urlParams.get('nonce'));
                        }
                    }
                    window.location.href = this.authService.authUri;
                    return;
                }
            }
        }
        // END - EDISSYUM - NCH01
    }

    goTo(route: string) {
        if (this.authService.mailServerOnline) {
            this.router.navigate([route]);
        } else {
            this.notify.error(this.translate.instant('lang.mailServerOffline'));
        }
    }
}
