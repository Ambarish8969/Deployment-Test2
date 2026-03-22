import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import updateAccounts from '@salesforce/apex/AccountController.updateAccounts';
import { refreshApex } from '@salesforce/apex';
import { showToast } from 'c/toastUtils';
import deleteAccs from '@salesforce/apex/AccountController.deleteAccs';
import getSearchedAccs from '@salesforce/apex/AccountController.getSearchedAccs';

import AccountNewModal from 'c/accountNewModal';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text', editable: true },
    { label: 'Industry', fieldName: 'Industry', type: 'text', editable: true },
    { label: 'Website', fieldName: 'Website', type: 'url', editable: true },
]

export default class ClientPagination1 extends LightningElement {

    @track data = [];
    @track allAccounts = [];
    columns = columns;
    draftValues;

    @track wiredResults;

    paginationSize = 10;
    pageNumber = 1;
    totalRecords = 0;
    totalPages = 0;

    @track selectedRows = [];

    @track accUserInput = '';

    @wire(getAccounts)
    getResults(result) {
        this.wiredResults = result;
        if (result.data) {
            this.allAccounts = result.data;
            this.totalRecords = this.allAccounts.length;

            this.totalPages = Math.ceil(this.totalRecords / this.paginationSize) || 1;

            this.setUpData();
            showToast(this, 'Accounts Loaded', 'Successfull', 'success');
        }
        else if (result.error) {

            console.log(result.error.body.message);
            showToast(this, 'Error', result.error.body.message, 'error');
        }
    }

    handleSave(event) {
        const updatedList = event.detail.draftValues;

        updateAccounts({ updatedAccs: updatedList })
            .then(() => {
                this.draftValues = [];
                showToast(this, 'Accounts Updated', 'Successfull', 'success');
                return refreshApex(this.wiredResults);
            })
            .catch((error) => {
                console.log(error);
                showToast(this, 'Error', error.body.message, 'error');
            })
    }

    handleSelection(event) {
        let currPageRecSelections = new Set();
        let globalRecordSelections = new Set(this.selectedRows);
        let currentPageRecords = new Set();

        this.data.forEach((ele) => {
            currentPageRecords.add(ele.Id);
        })

        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((ele) => {
                currPageRecSelections.add(ele.Id);
            })

            currPageRecSelections.forEach((ele) => {
                if (!globalRecordSelections.has(ele)) {
                    globalRecordSelections.add(ele);
                }
            })
        }

        currentPageRecords.forEach((ele) => {
            if (globalRecordSelections.has(ele) && !currPageRecSelections.has(ele)) {
                globalRecordSelections.delete(ele);
            }
        })

        this.selectedRows = [...globalRecordSelections];
    }

    handleAccKeyChange(event){
        this.accUserInput = event.target.value;

        getSearchedAccs({keyword : this.accUserInput})
        .then((result)=>{
            
            this.allAccounts = [...result];

            this.totalRecords = this.allAccounts.length;
            this.totalPages = Math.ceil(this.totalRecords / this.paginationSize) || 1;

            this.pageNumber = 1;
            this.setUpData();

        })
        .catch((error)=>{
            showToast(this,'Error for searched Acc', error.body.message,'error');
        })
    }

    deleteAccounts() {
        if(this.selectedRows.length !== 0){
            deleteAccs({ accIds: this.selectedRows })
            .then(() => {
                showToast(this, 'Deleted', 'Successfully', 'success')
                this.selectedRows = [];
                return refreshApex(this.wiredResults);

            })
            .catch((error) => {
                showToast(this, 'Error', error.body.message, 'error')
            })
        }
        else{
            showToast(this,'No rows selected','Please select rows to delete','error');
        }

    }

    addNewAccount(event) {
        try {
            const result = AccountNewModal.open({
                size: 'medium',
                description: 'NewAccount Modal',
                title: 'New Account',
            })

            if (result && result.saved) {
                showToast(this, 'Account Added', 'Successfully', 'success');
                return refreshApex(this.wiredResults);
            }
        }
        catch (error) {
            console.error('Error opening modal or refreshing data', error);
        }

    }

    setUpData() {
        const startIndex = (this.pageNumber - 1) * this.paginationSize;
        const endIndex = this.pageNumber * this.paginationSize;
        this.data = this.allAccounts.slice(startIndex, endIndex);

        this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRows;
    }

    handlePrevious() {
        if (this.pageNumber > 1) {
            this.pageNumber = this.pageNumber - 1;
            this.setUpData();
        }
    }

    handleNext() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber = this.pageNumber + 1;
            this.setUpData();
        }
    }

    get isFirstPage() {
        return this.pageNumber === 1;
    }

    get isLastPage() {
        return this.pageNumber === this.totalPages || this.pageNumber === 0;
    }


}