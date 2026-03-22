import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import udpateAccounts from '@salesforce/apex/AccountController.udpateAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const columns = [
    {label: 'Name', fieldName:'Name', type:'text', editable:true},
    {label: 'Industry', fieldName:'Industry', type:'text', editable:true},
]

export default class AccountList extends LightningElement {

    accList;
    columns = columns;
    wiredResults;
    @track draftValues = [];

    @wire(getAccounts)
    getAccountList(result){
        this.wiredResults = result;
        if(result.data){
            this.accList = result.data;
        }
        else if(result.error){
            console.log(result.error.body.message);
        }
    }

    handleSave(event){
        // detail.draftValues contains the Id and changed fields
        const updatedFields = event.detail.draftValues;

        udpateAccounts({accList :updatedFields})
        .then( (result) => {
            console.log('RESULT : ',result);
            this.showToast('Updated','Record Updated Successfully','success');
            
            // Clear draft values to hide the footer and reset cell highlights
            this.draftValues = [];
            return refreshApex(this.wiredResults);

        })
        .catch((error) => {
            console.log(error.body.message);
            this.showToast('Not Updated','There is an error while updating a record','error');
        })
    }

    showToast(title,message,variant){
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message : message,
            variant : variant,
        }))
    }

}