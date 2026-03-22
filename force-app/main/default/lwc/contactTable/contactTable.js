import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import { refreshApex } from '@salesforce/apex';

export default class ContactTable extends LightningElement {

    wiredResults;
    contacts;
    page = 1;
    size = 10;

    @wire(getContacts)
    contactResults(result){
        this.wiredResults = result
        if(result.data){
            this.contacts = result.data;
        }
        else if(result.error){
            console.log(result.error);
        }
    }

    get paged(){
        const start = (this.page -1) * this.size;
        return this.contacts.slice(start, start + this.size);
    }

    next(){
        this.page++;
    }

    prev(){
        this.page--;
    }

    refresh(){
        refreshApex(this.wiredResults);
    }

    sortName(){
        this.contacts = [...this.contacts].sort((a,b)=>a.Name > b.Name ? 1 : -1);
    }

    sortEmail(){
        this.contacts = [...this.contacts].sort((a,b)=> a.Email > b.Email ? 1 : -1);
    }

    sortPhone(){
        this.contacts = [...this.contacts].sort((a,b)=>a.Phone > b.Phone ? 1 : -1);
    }

}