import { LightningElement, api } from 'lwc';

export default class CompB extends LightningElement {

    @api parentmessage;
    inputValue = '';

    handleInputChange(event){
        this.inputValue = event.target.value;
    }

    handleSendButton(){
        this.dispatchEvent(new CustomEvent('messagefromchild',{detail:this.inputValue}));
    }

}