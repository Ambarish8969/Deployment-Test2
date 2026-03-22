import { LightningElement } from 'lwc';
import getCasesFromOrg2 from '@salesforce/apex/CaseWebServiceFromOrg2.getCasesFromOrg2';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    {label: 'Case Number', fieldName: 'CaseNumber', type:'String'},
    {label: 'Subject', fieldName: 'Subject', type:'String'},
    {label: 'Origin', fieldName: 'Origin', type:'String'},
    {label: 'Created Date', fieldName: 'CreatedDate', type:'Date'},
    {label: 'LastModified Date', fieldName: 'LastModifiedDate', type:'Date'},
]

export default class CaseTable extends LightningElement {

    data;
    columns = columns;

    async handleClick(){
        try{
            this.data = await getCasesFromOrg2();
            this.showToast('Success', 'Cases Fetched from Org 2', 'success');
        }
        catch(error){
            console.log('Error : ', error.body.message);
            this.showToast('Error', error.body.message, 'error');
        }
    }

    showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : message,
            variant : variant,
        }))
    }

}