import { track } from 'lwc';
import LightningModal from 'lightning/modal';
import { showToast } from 'c/toastUtils';

export default class AccountNewModal extends LightningModal {

    @track objectApiName = 'Account';

    handleCancel() {
        this.close({ saved: false });
    }

    handleSuccess(event) {
        const recId = event.detail.id;

        showToast(this, 'Account Created', 'Successfully', 'success');

        this.close({ saved: true , accountId : recId});
    }

    handleError() {
        showToast(this, 'Account Created', 'Successfully', 'success');
    }

}