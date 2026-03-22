import { LightningElement, wire } from 'lwc';
import { MessageContext, subscribe } from 'lightning/messageService';
import test from '@salesforce/messageChannel/test__c';

export default class Lms2 extends LightningElement {

    messageFromSibling = '';

    @wire(MessageContext) messageContext;

    connectedCallback() {
        subscribe(this.messageContext, test, (message) => {this.messageFromSibling = message.testField});
    }

    // connectedCallback() {
    //     subscribe(this.messageContext, test, (message) => {console.log(message.message)});
    // }

}