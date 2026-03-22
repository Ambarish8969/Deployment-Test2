import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { showToast } from 'c/toastUtils';

export default class NavigateToRecord extends NavigationMixin(LightningElement) {
    @api recordId;

    @api invoke(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes:{
                recordId : this.recordId,
                actionName : 'view',
            }
        })
        // this.dispatchEvent(new ShowToastEvent({
        //     title: 'Success',
        //     message : `Record Created Successfully ${this.recordId}`,
        //     variant : 'success',
        // }))

        showToast(this,'Success',`Contact Created Successfully Ambi ${this.recordId}`,'success');
    }

}