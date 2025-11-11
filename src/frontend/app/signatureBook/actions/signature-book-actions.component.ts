import { HttpClient } from '@angular/common/http';
import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { Router } from '@angular/router';
import { ActionsService } from '@appRoot/actions/actions.service';
import { FunctionsService } from '@service/functions.service';
import { NotificationService } from '@service/notification/notification.service';
import { Subscription, catchError, of, tap } from 'rxjs';
import { SignatureBookService } from '../signature-book.service';
import { UserStampInterface } from '@models/user-stamp.model';
import { Attachment } from "@models/attachment.model";
import { BasketGroupListActionInterface } from '@appRoot/administration/basket/list/list-administration.component';
import { Action } from '@models/actions.model';

@Component({
    selector: 'app-maarch-sb-actions',
    templateUrl: 'signature-book-actions.component.html',
    styleUrls: ['signature-book-actions.component.scss'],
    standalone: false
})
export class SignatureBookActionsComponent implements OnInit {
    @Input() resId: number;
    @Input() basketId: number;
    @Input() groupId: number;
    @Input() userId: number;
    @Input() userStamp: UserStampInterface;

    @Output() openPanelSignatures = new EventEmitter<true>();
    @Output() docsToSignUpdated = new EventEmitter<Attachment[]>();

    subscription: Subscription;

    loading: boolean = true;

    basketGroupActions: Action[] = [];

    refusalActions: Action[] = [];
    validationActions: Action[] = [];

    selectedValidationAction: Action;
    selectedRefusalAction: Action;

    constructor(
        public http: HttpClient,
        public functions: FunctionsService,
        public signatureBookService: SignatureBookService,
        private notify: NotificationService,
        private actionsService: ActionsService,
        private router: Router
    ) { }

    async ngOnInit(): Promise<void> {
        await this.getBasketGroupActions();
    }

    async getBasketGroupActions(): Promise<void> {
        await this.loadActions()
            .then(() => {
                this.refusalActions = [];
                this.validationActions = [];

                this.selectedValidationAction = null;
                this.selectedRefusalAction = null;

                const validationActionsIds: number[] = this.signatureBookService.basketGroupActions
                    .filter((action: BasketGroupListActionInterface) => action.type === 'valid')
                    .map((action: BasketGroupListActionInterface) => action.id);

                const refusalActionsIds: number[] = this.signatureBookService.basketGroupActions
                    .filter((action: BasketGroupListActionInterface) => action.type === 'reject')
                    .map((action: BasketGroupListActionInterface) => action.id);

                validationActionsIds.forEach((actionId: number) => {
                    const action: Action = this.basketGroupActions.find((action: Action) => action.id === actionId);
                    if (!this.functions.empty(action)) {
                        this.validationActions.push(action);
                    }
                });

                refusalActionsIds.forEach((actionId: number) => {
                    const action: Action = this.basketGroupActions.find((action: Action) => action.id === actionId);
                    if (!this.functions.empty(action)) {
                        this.refusalActions.push(action);
                    }
                });

                this.selectedValidationAction = this.validationActions[0];
                this.selectedRefusalAction = this.refusalActions[0];

            }).finally(() => {
                this.loading = false;
            })
            .catch((err: any) => {
                this.notify.handleSoftErrors(err);
                this.loading = false;
            });
    }

    loadActions(): Promise<Action[]> {
        return new Promise((resolve) => {
            this.actionsService
                .getActions(this.userId, this.groupId, this.basketId, this.resId)
                .pipe(
                    tap((actions: Action[]) => {
                        this.basketGroupActions = actions;
                        resolve(this.basketGroupActions);
                    }),
                    catchError((err: any) => {
                        this.notify.handleSoftErrors(err.error.errors);
                        resolve([]);
                        return of(false);
                    })
                )
                .subscribe();
        });
    }

    openSignaturesList(): void {
        this.openPanelSignatures.emit(true);
    }

    async processAction(action: any): Promise<void> {
        let resIds: number[] = [this.resId];
        resIds = resIds.concat(this.signatureBookService.selectedResources.map((resource: Attachment) => resource.resIdMaster));
        // Get docs to sign attached to the current resource by default if the selection is empty
        const docsToSign: Attachment[] = this.signatureBookService.selectedResources.length === 0 ? this.signatureBookService.docsToSign : this.signatureBookService.getAllDocsToSign();
        this.http
            .get(`../rest/resources/${this.resId}?light=true`)
            .pipe(
                tap((data: any) => {
                    this.actionsService.launchAction(
                        action,
                        this.userId,
                        this.groupId,
                        this.basketId,
                        [... new Set(resIds)],
                        { ...data, docsToSign: [... new Set(docsToSign)] },
                        false
                    );
                }),
                catchError((err: any) => {
                    this.notify.handleErrors(err);
                    return of(false);
                })
            )
            .subscribe();
    }

    processAfterAction(): void {
        this.backToBasket();
    }

    backToBasket(): void {
        const path = '/basketList/users/' + this.userId + '/groups/' + this.groupId + '/baskets/' + this.basketId;
        this.router.navigate([path]);
    }

    signWithStamp(userStamp: UserStampInterface): void {
        this.actionsService.emitActionWithData({
            id: 'selectedStamp',
            data: userStamp,
        });
    }

    canShowStamps(): boolean {
        const selectedDocAttachment = this.signatureBookService.selectedDocToSign.attachment;

        if (!selectedDocAttachment) {
            return true;
        }

        const hasDigitalSignature = selectedDocAttachment.hasDigitalSignature ?? false;
        if (!hasDigitalSignature) {
            return true;
        } else {
            return this.signatureBookService.currentWorkflowRole !== 'visa';
        }
    }
}
