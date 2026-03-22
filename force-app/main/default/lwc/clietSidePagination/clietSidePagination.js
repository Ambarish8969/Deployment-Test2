import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import updateContacts from '@salesforce/apex/ContactController.updateContacts';
import { showToast } from 'c/toastUtils';
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text', editable: true },
    { label: 'Last Name', fieldName: 'LastName', type: 'text', editable: true },
    { label: 'Email', fieldName: 'Email', type: 'email', editable: true },
    { label: 'Description', fieldName: 'Description', type: 'text', editable: true }
]

export default class ClietSidePagination extends LightningElement {

    @track allContacts = [];
    columns = columns;
    @track wiredResults;

    @track draftValues;
    @track contacts = [];

    @track selectedRows = [];

    //pagination state
    paginationSize = 10; // records per page
    @track pageNumber = 1;
    @track totalPages = 0;
    @track totalRecords = 0;

    get options() {
        return [
            { label: 5, value: 5 },
            { label: 10, value: 10 },
            { label: 20, value: 20 },
            { label: 30, value: 30 },
        ]
    }

    handleComboChange(event) {
        this.paginationSize = Number(event.detail.value);
        this.totalPages = Math.ceil(this.totalRecords / this.paginationSize) || 1;
        this.setPageData();
    }


    // Computed helpers for disabling buttons
    get isFirstPage() {
        return this.pageNumber === 1;
    }

    get isLastPage() {
        return this.pageNumber === this.totalPages || this.totalPages === 0;
    }


    @wire(getContacts)
    wiredContacts(result) {
        this.wiredResults = result;
        if (result.data) {
            this.allContacts = result.data;
            console.log(this.allContacts);

            this.totalRecords = this.allContacts.length;
            this.totalPages = Math.ceil(this.totalRecords / this.paginationSize) || 1;

            this.setPageData();
            showToast(this, 'Loaded', 'Record Successfully Loaded', 'success');
        }
        else if (result.error) {
            console.log(error.body.message);
            showToast(this, 'Error', result.error.body.message, 'error');
        }
    }

    setPageData() {
        const startIndex = (this.pageNumber - 1) * this.paginationSize;
        const endIndex = this.pageNumber * this.paginationSize;
        this.contacts = this.allContacts.slice(startIndex, endIndex);

        this.template.querySelector('[data-id="datatable"]').selectedRows = this.selectedRows;
    }

    handleSave(event) {
        const updatedFields = event.detail.draftValues;

        updateContacts({ updatedCons: updatedFields })
            .then(() => {
                this.draftValues = [];
                refreshApex(this.wiredResults);
                showToast(this, 'Updated', 'Record Successfully Updated', 'success');

                // after refresh we should re-calculate pagination as data may change
                this.totalRecords = this.allContacts.length;
                this.totalPages = Math.ceil(this.totalRecords / this.paginationSize) || 1;

                // keep user on same page if possible
                if (this.pageNumber > this.totalPages) {
                    this.pageNumber = this.totalPages;
                }
                this.setPageData();
                this.selectedRows = [];
            })
            .catch((error) => {
                showToast(this, 'Error while Updating', error.body.message, 'error');
            })
    }

    handleRowSelection(event) {
        let updatedItemsSet = new Set();

        let selectedItemsSet = new Set(this.selectedRows);

        let loadedItemsSet = new Set();

        this.contacts.map((ele) => {
            loadedItemsSet.add(ele.Id);
        });
        if (event.detail.selectedRows) {
            event.detail.selectedRows.map((ele) => {
                updatedItemsSet.add(ele.Id);
            });

            updatedItemsSet.forEach((id) => {
                if (!selectedItemsSet.has(id)) {
                    selectedItemsSet.add(id);
                }
            });
        }
        loadedItemsSet.forEach((id) => {
            if (selectedItemsSet.has(id) && !updatedItemsSet.has(id)) {
                selectedItemsSet.delete(id);
            }
        });
        this.selectedRows = [...selectedItemsSet];
        console.log('selectedRows==> ' + JSON.stringify(this.selectedRows));
    }

    handlePrevious() {

        if (this.pageNumber > 1) {
            this.pageNumber = this.pageNumber - 1;
            this.setPageData();
        }

    }

    handleNext() {

        if (this.pageNumber < this.totalPages) {
            this.pageNumber = this.pageNumber + 1;
            this.setPageData();
        }

    }
}