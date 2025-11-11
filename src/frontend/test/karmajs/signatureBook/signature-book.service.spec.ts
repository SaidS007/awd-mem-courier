import { fakeAsync, flush, TestBed, tick } from '@angular/core/testing';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { SignatureBookService } from "@appRoot/signatureBook/signature-book.service";
import { NotificationService } from "@service/notification/notification.service";
import { SharedModule } from "@appRoot/app-common.module";
import { TranslateLoader, TranslateModule } from "@ngx-translate/core";
import { Observable, of } from "rxjs";
import * as langFrJson from "@langs/lang-fr.json";
import { FiltersListService } from "@service/filtersList.service";
import { FoldersService } from "@appRoot/folder/folders.service";
import { DatePipe } from "@angular/common";
import { provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';

class FakeLoader implements TranslateLoader {
    getTranslation(): Observable<any> {
        return of({ lang: langFrJson });
    }
}

const resMock = {
    "resourcesToSign": [
        {
            "resId": 221,
            "resIdMaster": 100,
            "title": "Attachment resId 221",
            "chrono": "MAARCH/2024D/32",
            "creator": {
                "id": 21,
                "label": "Bernard BLIER"
            },
            "signedResId": 2,
            "type": "response_project",
            "typeLabel": "Projet de réponse",
            "isConverted": true,
            "canModify": false,
            "canDelete": false,
            "hasDigitalSignature":false,
            "externalDocumentId": 167,
            "originalFormat": "pdf",
            "version": 2,
            "creationDate": "2024-06-28T17:27:16+02:00",
            "modificationDate": "2024-06-28T17:27:16+02:00"
        },
        {
            "resId": 100,
            "resIdMaster": null,
            "title": "Main document resId 244",
            "chrono": "MAARCH/2024A/11",
            "creator": {
                "id": 21,
                "label": "Bernard BLIER"
            },
            "signedResId": null,
            "type": "main_document",
            "typeLabel": "Document Principal",
            "isConverted": true,
            "canModify": true,
            "canDelete": false,
            "hasDigitalSignature":false,
            "externalDocumentId": null,
            "originalFormat": "pdf",
            "version": 1,
            "creationDate": "2024-06-28T17:13:23+02:00",
            "modificationDate": "2024-06-28T17:34:00+02:00"
        }
    ],
    "resourcesAttached": [],
    "canSignResources": true,
    "canUpdateResources": false,
    "hasActiveWorkflow": false,
    "isCurrentWorkflowUser": false,
    "currentWorkflowRole": "sign"
};

describe('SignatureBook Service', () => {
    let signatureBookService: SignatureBookService, httpCtl: HttpTestingController;
    beforeEach(() => {
        TestBed.configureTestingModule({
    imports: [SharedModule,
        TranslateModule,
        TranslateModule.forRoot({
            loader: { provide: TranslateLoader, useClass: FakeLoader },
        })],
    providers: [
        FiltersListService,
        FoldersService,
        DatePipe,
        SignatureBookService,
        NotificationService,
        provideHttpClient(withInterceptorsFromDi()),
        provideHttpClientTesting()
    ]
});
        signatureBookService = TestBed.inject(SignatureBookService);
        httpCtl = TestBed.inject(HttpTestingController);
    });

    it('select a mail store resources to sign in service', fakeAsync(() => {
        signatureBookService.resetSelection();
        signatureBookService.toggleSelection(true, 1, 1, 1, 100);

        const req = httpCtl.expectOne('../rest/signatureBook/users/1/groups/1/baskets/1/resources/100');
        req.flush(resMock);

        tick(600);

        expect(signatureBookService.selectedResources.length).toEqual(2);
        expect(signatureBookService.selectedMailsCount).toEqual(1);

        flush();
    }));

    it('deselect a mail remove resources to sign stored in service', fakeAsync(() => {
        signatureBookService.resetSelection();
        signatureBookService.toggleSelection(true, 1, 1, 1, 100);

        const req = httpCtl.expectOne('../rest/signatureBook/users/1/groups/1/baskets/1/resources/100');
        req.flush(resMock);

        tick();

        signatureBookService.toggleSelection(false, 1, 1, 1, 100);

        tick();

        expect(signatureBookService.selectedResources.length).toEqual(0);
        expect(signatureBookService.selectedMailsCount).toEqual(0);

        flush();
    }));
});
