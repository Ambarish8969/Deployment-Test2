import { LightningElement, api } from 'lwc';

export default class CompA extends LightningElement {
    inputValue = '';
    @api LWCCompTest;

    messageToChild = '';
    messageFromChild = '';

    handleInputChange(event){
        this.inputValue = event.target.value;
    }

    handleButtonClick(){
        this.messageToChild = this.inputValue;
    }

    handleMessageFromChild(event){
        this.messageFromChild = event.detail;
    }
}