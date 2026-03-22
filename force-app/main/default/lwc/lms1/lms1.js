import { LightningElement, wire } from 'lwc';
import { MessageContext, publish } from 'lightning/messageService';
import TestChannel from '@salesforce/messageChannel/test__c';

export default class Lms1 extends LightningElement {

    inputValue;

    @wire(MessageContext) messageContext;

    handlePublish(){

        const payload = {
            testField : this.inputValue,
        }

        publish(this.messageContext, TestChannel, payload);
    }

    handleChange(event){
        this.inputValue = event.target.value;
    }

}