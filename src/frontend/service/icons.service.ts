import { Injectable } from '@angular/core';
import { MatIconRegistry } from '@angular/material/icon';
import { DomSanitizer } from '@angular/platform-browser';

@Injectable({
    providedIn: 'root'
})
export class IconService {
    constructor(
        private matIconRegistry: MatIconRegistry,
        private domSanitizer: DomSanitizer
    ) { }

    initializeIcons(): void {
        this.matIconRegistry.addSvgIcon('memLogo', this.domSanitizer.bypassSecurityTrustResourceUrl('assets/logo_only.svg'));
        this.matIconRegistry.addSvgIcon('memLogoFull', this.domSanitizer.bypassSecurityTrustResourceUrl('assets/logo.svg'));
        this.matIconRegistry.addSvgIcon('memLogoWhite', this.domSanitizer.bypassSecurityTrustResourceUrl('assets/logo_only_white.svg'));
        this.matIconRegistry.addSvgIcon('memLogoWhiteFull', this.domSanitizer.bypassSecurityTrustResourceUrl('assets/logo_white.svg'));
        this.matIconRegistry.addSvgIcon('alfresco', this.domSanitizer.bypassSecurityTrustResourceUrl('assets/alfresco.svg'));
        this.matIconRegistry.addSvgIcon('multigest', this.domSanitizer.bypassSecurityTrustResourceUrl('assets/multigest.svg'));
    }
}
