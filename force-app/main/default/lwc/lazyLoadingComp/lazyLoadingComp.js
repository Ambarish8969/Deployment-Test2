import { LightningElement} from 'lwc';
import getAllAccounts from '@salesforce/apex/AccountController.getAllAccounts';
import { showToast } from 'c/toastUtils';

const columns = [
    {label:'Account Name', fieldName: 'Name', type:'text'},
    {label:'Rating', fieldName: 'Rating', type:'text'},
    {label:'Industry', fieldName: 'Industry', type:'text'},
]

export default class LazyLoadingComp extends LightningElement {

    accounts = [];
    columns = columns;
    totalNumberOfRows = 200; // stop the infinite load after this threshold count

    loadMoreStatus;
    targetDatatable; // capture the loadmore event to fetch data and stop infinite loading

    rowLimit  = 50;
    rowOffSet = 0;

    connectedCallback(){
        this.loadData();
    }

    loadData(){
        return getAllAccounts({limitSize:this.rowLimit, offset:this.rowOffSet})
        .then(result => {
            //console.log('Results: ',result);
            let fechedAccs = [...this.accounts, ...result];
            this.accounts = fechedAccs;
            this.loadMoreStatus = '';
            if (this.targetDatatable && this.accounts.length >= this.totalNumberOfRows) {
                //stop Infinite Loading when threshold is reached
                this.targetDatatable.enableInfiniteLoading = false;
                //Display "No more data to load" when threshold is reached
                this.loadMoreStatus = 'No more data to load';
            }
            //Disable a spinner to signal that data has been loaded
            if (this.targetDatatable) this.targetDatatable.isLoading = false;
            //console.log('DATA: ', this.accounts);
        })
        .catch(error =>{
            showToast(this, 'Error while fetching records', error.body.message, 'error');
        })
    }

    loadMoreData(event) {
        event.preventDefault();
		
        // increase the offset count by 20 on every loadmore event
        this.rowOffSet = this.rowOffSet + 20;
		
        //Display a spinner to signal that data is being loaded
        event.target.isLoading = true;
		
        //Set the onloadmore event taraget to make it visible to imperative call response to apex.
        this.targetDatatable = event.target;
		
        //Display "Loading" when more data is being loaded
        this.loadMoreStatus = 'Loading';
		
        // Get new set of records and append to this.accounts
        this.loadData();   
    }

}