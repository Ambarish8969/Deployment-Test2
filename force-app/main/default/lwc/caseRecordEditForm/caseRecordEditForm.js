import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class CaseRecordEditForm extends NavigationMixin(LightningElement) {

    pickVal;
    @track showOtherFields = false;
    @track isPriorityHigh = false;

    // handleLoad(){
    //     const priorityField = this.template.querySelector('lightning-input-field[data-field="Priority"]');
    //     if(priorityField){
    //         priorityField.value = null;
    //     }
    // }

    handlePriorityChange(event){
        this.pickVal = event.detail.value;
        if(this.pickVal == 'High'){
            this.showOtherFields = true;
            this.isPriorityHigh = true;
        }
        else if(this.pickVal == 'Medium' || this.pickVal == 'Low'){
            this.showOtherFields = true;
            this.isPriorityHigh = false;
        }
    }

    handleSuccess(event){
        this.customToastEvent('Case Created '+event.detail.id,'Creatd Successfully', 'success');
        this[NavigationMixin.Navigate]({
            type : 'standard__recordPage',
            attributes : {
                objectApiName : 'Case',
                recordId : event.detail.id,
                actionName : 'view',
            }
        })
    }

    handleError(event){
        this.customToastEvent('Error creating case','Not Created', event.detail);
    }

    customToastEvent(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : message,
            variant : variant,
        }))
    }

}