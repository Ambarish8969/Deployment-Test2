import { LightningElement, api, track } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactCreation extends LightningElement {

    @api firstname;
    @api lastname;
    @api contacttype;

    @track pickVal = '';
    @track contactTypeVal = '';
    @track firstNameVal = '';
    @track lastNameVal = '';
    @track emailVal = '';
    @track phoneVal = '';
    @track mobilePhoneVal = '';

    @track showOtherFields = false;
    @track isVIP = false;

    handleContactType(event){
        this.pickVal = event.detail.value;
        this.contacttype = this.pickVal;
        if(this.pickVal == 'VIP'){
            this.showOtherFields = true;
            this.isVIP = true;
        }else if(this.pickVal == 'Normal'){
            this.showOtherFields = true;
            this.isVIP = false;
        }
    }

    get contactTypeOptions() {
        return [
            { label: 'Normal', value: 'Normal' },
            { label: 'VIP', value: 'VIP' }
        ];
    }

    handleFirstNameVal(event){
        this.firstNameVal = event.detail.value;
        this.firstname = this.firstNameVal;
    }

    handleLastName(event){
        this.lastNameVal = event.detail.value;
        this.lastname = this.lastNameVal;
    }

    handleEmailVal(event){
        this.emailVal = event.detail.value;
    }   

    handlePhoneVal(event){
        this.phoneVal = event.detail.value;
    }

    handleMobilePhoneVal(event){
        this.mobilePhoneVal = event.detail.value;
    }

    handleButtonClick(event){

        const nextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(nextEvent);

        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Contact Created Successfully',
            variant: 'success'
        }))
    }

}