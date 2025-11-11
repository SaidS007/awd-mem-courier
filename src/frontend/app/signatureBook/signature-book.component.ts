import { Component, HostListener, OnDestroy, ViewChild } from '@angular/core';
import { ActionsService } from '@appRoot/actions/actions.service';
import { HttpClient } from '@angular/common/http';
import { ActivatedRoute, Router } from '@angular/router';
import { NotificationService } from '@service/notification/notification.service';
import { filter, tap, catchError, of } from 'rxjs';
import { Subscription } from 'rxjs';
import { MatDrawer } from '@angular/material/sidenav';
import { Attachment } from '@models/attachment.model';
import { MessageActionInterface } from '@models/actions.model';
import { SignatureBookService } from './signature-book.service';
import { ResourcesListComponent } from './resourcesList/resources-list.component';
import { TranslateService } from '@ngx-translate/core';
import { FunctionsService } from '@service/functions.service';
import { UserStampInterface } from '@models/user-stamp.model';
import { SelectedAttachment, SignatureBookDataReturnInterface } from "@models/signature-book.model";
import { SignatureBookActionsComponent } from "@appRoot/signatureBook/actions/signature-book-actions.component";

@Component({
    templateUrl: 'signature-book.component.html',
    styleUrls: ['signature-book.component.scss'],
    standalone: false
})
export class SignatureBookComponent implements OnDestroy {

    @ViewChild('drawerStamps', { static: true }) stampsPanel: MatDrawer;
    @ViewChild('drawerResList', { static: false }) drawerResList: MatDrawer;
    @ViewChild('resourcesList', { static: false }) resourcesList: ResourcesListComponent;
    @ViewChild('actionsList', { static: false }) actionsList: SignatureBookActionsComponent;

    loadingAttachments: boolean = true;
    loadingDocsToSign: boolean = true;
    loading: boolean = true;

    resId: number = 0;
    basketId: number;
    groupId: number;
    userId: number;

    attachments: Attachment[] = [];
    docsToSign: Attachment[] = [];

    subscription: Subscription;
    defaultUserStamp: UserStampInterface;

    processActionSubscription: Subscription;

    canGoToNext: boolean = false;
    canGoToPrevious: boolean = false;
    hidePanel: boolean = true;

    constructor(
        public http: HttpClient,
        public signatureBookService: SignatureBookService,
        public translate: TranslateService,
        public functions: FunctionsService,
        private route: ActivatedRoute,
        private router: Router,
        private notify: NotificationService,
        private actionsService: ActionsService,
    ) {

        this.initParams();

        this.subscription = this.actionsService.catchActionWithData().pipe(
            filter((data: MessageActionInterface) => data.id === 'selectedStamp'),
            tap(() => {
                this.stampsPanel?.close();
            })
        ).subscribe();

        // Event after process action
        this.processActionSubscription = this.actionsService.catchAction().subscribe(() => {
            this.processAfterAction();
        });
    }

    @HostListener('window:unload', [ '$event' ])
    async unloadHandler(): Promise<void> {
        this.unlockResource();
        this.signatureBookService.resetSelection();
    }

    initParams(): void {
        this.route.params.subscribe(async params => {
            this.resetValues();

            this.resId = parseInt(params['resId']);
            this.basketId = parseInt(params['basketId']);
            this.groupId = parseInt(params['groupId']);
            this.userId = parseInt(params['userId']);

            if (!this.signatureBookService.config.isNewInternalParaph) {
                this.router.navigate([`/signatureBook/users/${this.userId}/groups/${this.groupId}/baskets/${this.basketId}/resources/${this.resId}`]);
                return;
            }

            if (this.resId !== undefined) {
                this.actionsService.lockResource(this.userId, this.groupId, this.basketId, [this.resId]);
                this.setNextPrev();
                await this.initDocuments();
            } else {
                this.router.navigate(['/home']);
            }
        });
    }

    setNextPrev() {
        const index: number = this.signatureBookService.resourcesListIds.indexOf(this.resId);
        this.canGoToNext = this.signatureBookService.resourcesListIds[index + 1] !== undefined;
        this.canGoToPrevious = this.signatureBookService.resourcesListIds[index - 1] !== undefined;
    }

    resetValues(): void {
        this.loading = true;
        this.loadingDocsToSign = true;
        this.loadingAttachments = true;

        this.attachments = [];
        this.signatureBookService.docsToSign = [];

        this.subscription?.unsubscribe();
    }

    async initDocuments(): Promise<void>{
        await this.signatureBookService.initDocuments(this.userId, this.groupId, this.basketId, this.resId).then((data: SignatureBookDataReturnInterface) => {
            this.signatureBookService.canUpdateResources = data.canUpdateResources;

            this.signatureBookService.selectedAttachment = new SelectedAttachment();
            this.signatureBookService.selectedDocToSign = new SelectedAttachment();

            this.signatureBookService.toolBarActive = data.resourcesAttached.length === 0;
            this.signatureBookService.docsToSign = data.resourcesToSign;
            this.attachments = data.resourcesAttached;
            this.loadingAttachments = false;
            this.loadingDocsToSign = false;
            this.loading = false;
        });
    }

    async processAfterAction() {
        if (this.canGoToNext) {
            this.goToNextUnlockedResource();
        } else {
            this.backToBasket();
        }
    }

    backToBasket(): void {
        const path = '/basketList/users/' + this.userId + '/groups/' + this.groupId + '/baskets/' + this.basketId;
        this.router.navigate([path]);
    }

    ngOnDestroy(): void {
        // unsubscribe to ensure no memory leaks
        this.subscription.unsubscribe();
        this.processActionSubscription.unsubscribe();
        this.unlockResource();
        this.signatureBookService.resetSelection();
        this.signatureBookService.docsToSignWithStamps = [];
    }

    async unlockResource(): Promise<void> {
        const path = '/basketList/users/' + this.userId + '/groups/' + this.groupId + '/baskets/' + this.basketId;
        this.actionsService.stopRefreshResourceLock();
        await this.actionsService.unlockResource(this.userId, this.groupId, this.basketId, [this.resId], path);
    }

    openResListPanel() {
        setTimeout(() => {
            this.drawerResList.open();
        }, 300);
    }

    showPanelContent() {
        this.resourcesList.initViewPort();
    }

    docsToSignUpdated(updatedDocsToSign: Attachment[]): void {
        this.docsToSign = updatedDocsToSign;
    }

    onRefreshVisaWorkflow(): void {
        this.actionsList.getBasketGroupActions();
    }

    goToNextUnlockedResource(): void {
        const index: number = this.signatureBookService.resourcesListIds.indexOf(this.resId);
        const c: number = this.signatureBookService.resourcesListIds.length;

        const tabRemainResources: number[] = [];
        for (let i = index + 1; i < c; i++) {
            tabRemainResources.push(this.signatureBookService.resourcesListIds[i]);
        }
        this.http.put(`../rest/resourcesList/users/${this.userId}/groups/${this.groupId}/baskets/${this.basketId}/locked`, { resources: tabRemainResources }).pipe(
            tap((data: any) => {
                let nextResId: number = -1;
                for (let j= 0; j < tabRemainResources.length; j++) {
                    if (data.resourcesToProcess.includes(tabRemainResources[j])) {
                        nextResId = tabRemainResources[j];
                        break;
                    }
                }

                if (nextResId !== -1) {
                    const path: string = `/signatureBookNew/users/${this.userId}/groups/${this.groupId}/baskets/${this.basketId}/resources/${nextResId}`;
                    this.router.navigate([path]);
                } else {
                    this.backToBasket();
                }
            }),
            catchError((err: any) => {
                this.notify.handleSoftErrors(err);
                return of(false);
            })
        ).subscribe();
    }
}
