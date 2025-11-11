import { Subject, Observable } from 'rxjs';
import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class SereniaChatbotService {
    private subject: Subject<void> = new Subject<void>();
    public chatObs$: Observable<void> = this.subject.asObservable();

    actionEvent: any;
    resId: string = '';
    enable: boolean = false;
    actionsList: any[] = [];
    messagesList: any[] = [];
    showDialog: boolean = false;
    keepSereniaIcon: boolean = false;
    newNotification: boolean = false;

    refresh() {
        this.subject.next();
    }
}
