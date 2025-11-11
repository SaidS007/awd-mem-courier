import { Component, OnInit, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { HeaderService } from '@service/header.service';
import { HttpClient } from '@angular/common/http';
import { TranslateService } from '@ngx-translate/core';
import { tap, catchError, finalize } from 'rxjs/operators';
import { of } from 'rxjs';
import { NotificationService } from '@service/notification/notification.service';

@Component({
    selector: 'app-ai-merge-contact',
    templateUrl: './ai-merge-contact.component.html',
    styleUrls: ['./ai-merge-contact.component.scss'],
    standalone: false
})
export class AiMergeContactComponent implements OnInit {
    loading: boolean = false;
    finalContact: any = null;

    fields = [
        { 'id': 'company', label: this.translate.instant('lang.contactsParameters_company'), icon: 'far fa-building', selected: 0 },
        { 'id': 'lastname', label: this.translate.instant('lang.lastname'), icon: 'fas fa-user', selected: 0 },
        { 'id': 'firstname', label: this.translate.instant('lang.firstname'), icon: 'fas fa-user', selected: 0 },
        { 'id': 'email', label: this.translate.instant('lang.email'), icon: 'far fa-envelope', selected: 0 },
        { 'id': 'phone', label: this.translate.instant('lang.phoneNumber'), icon: 'fas fa-phone', selected: 0 },
        { 'id': 'addressNumber', label: this.translate.instant('lang.contactsParameters_addressNumber'), icon: 'fas fa-location-dot', selected: 0 },
        { 'id': 'addressStreet', label: this.translate.instant('lang.contactsParameters_addressStreet'), icon: 'fas fa-location-dot', selected: 0 },
        { 'id': 'addressPostcode', label: this.translate.instant('lang.contactsParameters_addressPostcode'), icon: 'fas fa-location-dot', selected: 0 },
        { 'id': 'addressTown', label: this.translate.instant('lang.contactsParameters_addressTown'), icon: 'fas fa-location-dot', selected: 0 }
    ]

    constructor(
        public translate: TranslateService,
        public http: HttpClient,
        private notify: NotificationService,
        @Inject(MAT_DIALOG_DATA) public data: any,
        public dialogRef: MatDialogRef<AiMergeContactComponent>,
        public headerService: HeaderService
    ) {}

    ngOnInit() {
        this.loading = true;
        this.data.duplicate.forEach((element: any, index: number) => {
            this.http.get('../rest/contacts/' + element.id).pipe(
                tap((contact: any) => {
                    Object.keys(contact).forEach((data: any) => {
                        element[data] = contact[data];
                    });
                    if (index === 0) {
                        this.finalContact = JSON.parse(JSON.stringify(element));
                    }
                }),
                finalize(() => {
                    this.loading = false;
                }),
                catchError((err: any) => {
                    this.notify.error(err.error.errors);
                    return of(false);
                })
            ).subscribe();
        });
    }

    onSubmit() {
        const tmpContactId = this.finalContact['externalId']['ia_tmp_contact_id'];
        if (this.finalContact['externalId']['ia_tmp_contact_id']) {
            delete this.finalContact['externalId']['ia_tmp_contact_id'];
        }

        if (typeof this.finalContact['civility'] === 'object' && this.finalContact['civility'] !== null) {
            this.finalContact['civility'] = this.finalContact['civility']['id'];
        }
        this.http.put(`../rest/contacts/${this.finalContact['id']}`, this.finalContact).pipe(
            tap(() => {
                this.notify.success(this.translate.instant('lang.contactUpdated'));
                this.http.delete(`../rest/contacts/${tmpContactId}`).pipe(
                    catchError((err: any) => {
                        this.notify.handleErrors(err);
                        return of(false);
                    })
                ).subscribe();
                this.dialogRef.close(this.finalContact);
            }),
            catchError((err: any) => {
                this.notify.handleErrors(err);
                return of(false);
            })
        ).subscribe();
    }

    createContact() {
        const contactId = this.finalContact['id'];
        delete this.finalContact['id'];

        const tmpContactId = this.finalContact['externalId']['ia_tmp_contact_id'];
        if (this.finalContact['externalId']['ia_tmp_contact_id']) {
            delete this.finalContact['externalId']['ia_tmp_contact_id'];
        }

        if (typeof this.finalContact['civility'] === 'object' && this.finalContact['civility'] !== null) {
            this.finalContact['civility'] = this.finalContact['civility']['id'];
        }
        this.http.post(`../rest/contacts`, this.finalContact).pipe(
            tap((data: any) => {
                this.notify.success(this.translate.instant('lang.contactAdded'));
                let label = ''
                if (this.finalContact['lastname'] && this.finalContact['firstname']) {
                    label = `${this.finalContact['firstname']} ${this.finalContact['lastname']}`;
                } else if (this.finalContact['lastname']) {
                    label = this.finalContact['lastname'];
                } else if (this.finalContact['company']) {
                    label = this.finalContact['company'];
                }
                this.finalContact['id'] = data['id'];
                const contact_data = {
                    'id': data['id'],
                    'label': label,
                    'type': 'contact',
                    'status': 'OK',
                    'externalId': {}
                }
                this.data.currentResourceInformations.senders.forEach((element: any, cpt: number) => {
                    if (element['id'] === contactId) {
                        this.data.currentResourceInformations.senders[cpt] = contact_data;
                    }
                });
                this.http.put(`../rest/resources/${this.data.currentResourceInformations.resId}?fromProcess=`  + false, this.data.currentResourceInformations).pipe(
                    tap(() => {
                        this.http.delete(`../rest/contacts/${tmpContactId}`).pipe(
                            catchError((err: any) => {
                                this.notify.handleErrors(err);
                                return of(false);
                            })
                        ).subscribe();
                    }),
                    catchError((err: any) => {
                        this.notify.handleSoftErrors(err);
                        return of(false);
                    })
                ).subscribe();
                this.dialogRef.close(this.data.currentResourceInformations.senders);
            }),
            catchError((err: any) => {
                this.notify.handleErrors(err);
                return of(false);
            })
        ).subscribe();
    }

    chooseOption(index: number, field: any) {
        this.fields.forEach((element) => {
            if (element.id === field.id) {
                element.selected = index;
                this.finalContact[field.id] = this.data.duplicate[index][field.id];
            }
        });
    }

    updateField(index, field, data) {
        this.fields.forEach((element) => {
            if (element.id === field.id) {
                element.selected = index;
                this.finalContact[field.id] = data;
            }
        });
    }
}
