import { LightningElement, wire, track, api } from 'lwc';
import getSearchedAccs from '@salesforce/apex/AccountController.getSearchedAccs';

const columns =[
    {label:'Name', fieldName: 'Name', type:'text',},
    {label:'Industry', fieldName: 'Industry', type:'text',},
    {label:'Website', fieldName: 'Website', type:'url',},
]

export default class SearchComp extends LightningElement {

    inputValue = '';
    @track accounts;
    columns = columns

    handleInputChange(event){
        this.inputValue = event.target.value;
    }

    @wire(getSearchedAccs,{keyword : '$inputValue'})
    getAccounts({data, error}){
        if(data){
            this.accounts = data;
        }
        else if(error){
            console.log(error.body.message);
        }
    }

    get isDataPresent(){
        if(this.inputValue == null || this.inputValue == ''){
            return false;
        }
        else {
            return true;
        }
    }

}