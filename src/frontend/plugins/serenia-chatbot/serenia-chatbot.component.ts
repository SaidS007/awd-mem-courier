import { Component, EventEmitter, ChangeDetectorRef, Input, OnChanges, Output, inject } from "@angular/core";
import { FormControl } from "@angular/forms";
import { HttpClient, HttpDownloadProgressEvent, HttpEvent, HttpEventType } from "@angular/common/http";
import { TranslateService } from "@ngx-translate/core";
import { marked } from "marked";
import { Subscription } from 'rxjs';
import { SereniaChatbotService } from "@plugins/serenia-chatbot/serenia-chatbot-service.component";
import { Router } from "@angular/router";
import * as moment from 'moment-timezone';

@Component({
    selector: 'app-serenia-chatbot',
    templateUrl: 'serenia-chatbot.component.html',
    styleUrls: ['serenia-chatbot.component.scss'],
    standalone: false
})

export class SereniaChatbotComponent implements OnChanges {
    private sub = new Subscription();
    private cdr = inject(ChangeDetectorRef);

    @Input() resId: string = '';
    @Input() actionsList: any[] = [];
    @Input() enable: boolean = false;
    @Input() messagesList: any[] = [];
    @Input() showDialog: boolean = false;
    @Input() newNotification: boolean = false;
    @Input() keepSereniaIcon: boolean = false;

    @Output() actionEvent = new EventEmitter<any>();

    sereniaProcessing: boolean = false;
    sereniaThinking: boolean = false;

    messages: any[] = [];
    sereniaImageClass: string = '';
    disabled_messages: any[] = [
        {
            "show": false,
            "content": "lang.serenia_default_message_1"
        },
        {
            "show": false,
            "content": "lang.serenia_disabled_message_1"
        },
        {
            "show": false,
            "content": "lang.serenia_disabled_message_2"
        },
        {
            "show": false,
            "content": "lang.serenia_disabled_message_3"
        }
    ];

    userMessageControl: any = new FormControl();
    noNotificationsMessages: any[] = [
        {
            "show": false,
            "user": false,
            "content": 'lang.serenia_default_message_1'
        },
        {
            "show": false,
            "user": false,
            "content": 'lang.serenia_default_message_2'
        },
        {
            "show": false,
            "user": false,
            "content": 'lang.serenia_default_message_3'
        }
    ];

    sereniaService = inject(SereniaChatbotService);
    unallowedRoutes = [
        '/login',
        '/forgot-password',
        '/password-modification',
        '/activate-user',
        '/signatureBook',
        '/install'
    ];

    constructor(
        public router: Router,
        private http: HttpClient,
        private translate: TranslateService
    ) {
        this.sub.add(
            this.sereniaService.chatObs$.subscribe(() => {
                this.cdr.detectChanges();
            })
        );
    }

    ngOnChanges() {
        if (!this.enable) {
            this.messages = this.disabled_messages;
            return;
        }

        this.messages = [
            {
                "show": false,
                "user": false,
                "content": "lang.serenia_default_message_1"
            }
        ];

        if (!this.keepSereniaIcon) {
            this.messages = this.noNotificationsMessages
        } else {
            this.sereniaImageClass = 'serenia_enabled';
            this.messagesList.forEach((message) => {
                this.messages.push({
                    "show": false,
                    "user": false,
                    "content": message
                });
            });
        }

        this.actionsList.forEach((action) => {
            action.show = false;
        });

        if ((this.keepSereniaIcon && this.enable) || this.showDialog) {
            this.sereniaImageClass = 'serenia_enabled';
        } else {
            this.sereniaImageClass = '';
        }
    }

    toggleDialogPopup() {
        this.newNotification = false;
        this.showDialog = !this.showDialog;
        setTimeout(() => {
            this.ngOnChanges();
            setTimeout(() => {
                let messages = this.messages;
                if (!this.enable) {
                    messages = this.disabled_messages;
                }
                messages.forEach((message, index) => {
                    setTimeout(() => {
                        message.show = true;
                        if (index === messages.length - 1) {
                            setTimeout(() => {
                                if (this.actionsList.length > 0) {
                                    messages.push({
                                        "action": true
                                    })
                                }

                                this.actionsList.forEach((action, index) => {
                                    setTimeout(() => {
                                        action.show = true;
                                    }, 600 * index);
                                });
                            }, 400);
                        }
                    }, 600 * index);
                });
            }, 400);
        }, 200);
    }

    emitAction(action: any) {
        this.actionEvent.emit(action);
    }

    sendMessage() {
        const today = moment.tz(new Date(), 'Europe/Paris');
        const hour = today.get('hour');
        const day = today.get('day');

        if (this.enable && !this.sereniaProcessing && this.userMessageControl.value.trim()) {
            this.sereniaProcessing = true;
            this.sereniaThinking = true;
            const message = this.userMessageControl.value;
            this.messages.push({
                "show": true,
                "user": true,
                "content": message
            });
            this.userMessageControl.setValue('');
            setTimeout(() => {
                document.getElementsByClassName('serenia_dialog_body')[0]?.scrollTo({
                    top: document.getElementsByClassName('serenia_dialog_body')[0]?.scrollHeight,
                    behavior: 'smooth'
                });
            }, 50)

            if (hour < 8 || hour > 18 || (day > 5)) {
                this.sereniaProcessing = false;
                this.sereniaThinking = false;
                this.userMessageControl.setValue('');
                this.messages.push({
                    "show": true,
                    "user": false,
                    "content": this.translate.instant('lang.serenia_disabled_hours')
                });
                return;
            }

            this.http.post('../rest/serenia/chatbot', { 'message': message, 'resId': this.resId }, {
                observe: 'events',
                responseType: 'text',
                reportProgress: true
            }).subscribe({
                next: (event: HttpEvent<string>) => {
                    if (event['status'] !== 500 && event['status'] !== 400 && event['status'] !== 404 && event['status'] !== 403) {
                        let content: string;
                        if (event.type === HttpEventType.DownloadProgress) {
                            this.sereniaThinking = false;
                            content = (event as HttpDownloadProgressEvent).partialText;
                        } else if (event.type === HttpEventType.Response) {
                            this.sereniaProcessing = false;
                            content = event.body;
                        }

                        if (content) {
                            let error = undefined;
                            try {
                                error = JSON.parse(content)['errors'];
                                if (!error) {
                                    error = JSON.parse(content)['detail'];
                                }
                                if (!error) {
                                    error = JSON.parse(content)['message'];
                                }
                                if (error) {
                                    const lastMessage = this.messages[this.messages.length - 1];
                                    if (!lastMessage.content.includes(error)) {
                                        this.sereniaThinking = false;
                                        this.sereniaProcessing = false;
                                        this.messages.push({
                                            "show": true,
                                            "user": false,
                                            "content": this.translate.instant('lang.serenia_error_message') + ' : <strong>' + error + '</strong>'
                                        });
                                    }
                                }
                            }
                            catch { /* empty */ }

                            if (!error) {
                                const lastMessage = this.messages[this.messages.length - 1];
                                if (lastMessage['ia']) {
                                    const urlRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|])/ig;
                                    content = content.replace(urlRegex, '<a href="$1" target="_blank">$1</a>');
                                    content = content.replace(/\n/g, '<br>');

                                    this.messages[this.messages.length - 1].content = marked(content);
                                    document.getElementsByClassName('serenia_dialog_body')[0]?.scrollTo({
                                        top: document.getElementsByClassName('serenia_dialog_body')[0]?.scrollHeight,
                                        behavior: 'smooth'
                                    });
                                } else {
                                    this.messages.push({
                                        "show": true,
                                        "ia": true,
                                        "user": false,
                                        "content": marked(content)
                                    });
                                }
                            }
                        }
                    }
                },
                error: () => {
                    this.sereniaThinking = false;
                    this.sereniaProcessing = false;
                }
            });
        }
    }

    shouldShowChatbot() {
        return !this.unallowedRoutes.some(route => this.router.url.startsWith(route));    }
}
