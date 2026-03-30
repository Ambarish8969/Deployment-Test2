import { LightningElement, wire } from 'lwc';
import getAccountByName from '@salesforce/apex/AccountController.getAccountByName';

export default class AccReactive extends LightningElement {

    inputAccName = '';

    accountName;
    accountIndustry;

    handleInput(event){
        this.inputAccName = event.target.value;
    }

    @wire(getAccountByName, {accName:'$inputAccName'})
    getAccount({data:ambi, error:nambi}){
        if(ambi){
            console.log('Ambi: ',ambi);
            this.accountName = ambi.Name;
            this.accountIndustry = ambi.Industry;
        }
        else if(nambi){
            console.log('Error: ', nambi.body.message);
        }
    }
}