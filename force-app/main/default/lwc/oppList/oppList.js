import { LightningElement } from 'lwc';
import getOpps from '@salesforce/apex/OpportunityController.getOpps';
import updateOppFields from '@salesforce/apex/OpportunityController.updateOppFields';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

const columns = [
    {label:'Name', fieldName:'Name',type:'String', editable:true},
    {label:'Stage', fieldName:'StageName',type:'String', editable:true},
    {label:'Close Date', fieldName:'CloseDate',type:'date', editable:true},
]

export default class OppList extends LightningElement {

    isClicked = false;
    data;
    columns = columns;
    draftValues = [];
    fetchedResults;

    handleClick(){
        this.isClicked = true;
        this.fetchOpps();
    }

    fetchOpps(){
        getOpps()
        .then((result)=>{
            this.data = result;
            this.fetchedResults = result;
        })
        .catch((error)=>{
            console.log('Error: ', error.body.message);
        })
    }

    handleSave(event){
        const updatedFields = event.detail.draftValues;

        updateOppFields({oppsFields : updatedFields})
        .then(()=>{

            this.showToast('Updated', 'Successfully Updated', 'success');
            this.draftValues = [];
            this.fetchOpps();
            //return refreshApex(this.fetchedResults); //this will not work for Imperative call
        })
        .catch((error)=>{
            console.log(error);
            this.showToast('Not Updated',error.body.message, 'error');
        })
    }

    showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        }))
    }

}