import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class UpdateContactComp extends NavigationMixin(LightningElement) {

    @api objectApiName;
    @api recordId;

    handleSuccess(event){
        console.log(event);
        this.dispatchShowToast('Updated',`Record updated Successfully ${event.detail.id}`, 'success');
        this[NavigationMixin.Navigate]({
            type : 'standard__recordPage',
            attributes : {
                actionName : 'view',
                recordId : this.recordId,
            }
        })
    }

    handleError(event){
        console.log(event.detail);
        this.dispatchShowToast('Not Updated', event.detail,'error');
    }

    dispatchShowToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }))
    }

}