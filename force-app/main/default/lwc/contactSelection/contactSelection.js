import { LightningElement, wire, track } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

const columns  = [
    {label:'Name', fieldName : 'Name', type: 'text', editable:true},
    {label:'Email', fieldName : 'Email', type: 'email', editable:true},
    {label:'Phone', fieldName : 'Phone', type: 'phone', editable:true},
    // {label:'Account Name', fieldName : 'AccountId', type: 'text', editable:true},
]

export default class ContactSelection extends LightningElement {
    columns = columns;
    @track contacts = [];
    @track allContacts = [];

    @track wiredResult;

    paginationSize = 10;
    totalRecords = 0;
    totalPages = 0;
    pageNumber = 1;

    @wire(getContacts)
    getRecords(result){
        this.wiredResult = result;
        if(result.data){
            this.allContacts = result.data;
            this.totalRecords = this.allContacts.length;

            this.totalPages = Math.ceil(this.totalRecords / this.paginationSize) || 1;

            this.setUpData();
        }
        else if(result.error){
            console.log(result.error.body.message);
        }
    }

    setUpData(){
        const startIndex = (this.pageNumber - 1) * this.paginationSize;
        const endIndex = this.pageNumber * this.paginationSize;
        this.contacts = this.allContacts.slice(startIndex,endIndex);
    }

    handlePrevious(){
        if(this.pageNumber > 1){
            this.pageNumber = this.pageNumber - 1;
            this.setUpData();
        }
    }

    handleNext(){
        if(this.pageNumber < this.totalPages){
            this.pageNumber = this.pageNumber + 1;
            this.setUpData();
        }
    }

    get isFirstPage(){
        return this.pageNumber === 1;
    }

    get isLastPage(){
        return this.pageNumber === this.totalPages || this.totalPages == 0;
    }
}