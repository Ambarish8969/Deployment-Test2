import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCaseDetails from '@salesforce/apex/CaseServiceConsoleController.getCaseDetails';

export default class WarrantyAndTroubleshooting extends NavigationMixin(LightningElement) {
    // Automatically get the ID of the Case record this component is on
    @api recordId;

    // Store the data and error from the @wire call
    wireResult;
    warrantyInfo;
    articles;
    error;

    // Use @wire to call the Apex method automatically when recordId is available
    // The result is stored in 'wireResult'
    @wire(getCaseDetails, { caseId: '$recordId' })
    wiredCaseDetails(result) {
        this.wireResult = result; // Store the raw result
        if (result.data) {
            // Success: assign the data to our properties
            this.warrantyInfo = result.data.warranty;
            this.articles = result.data.articles;
            this.error = undefined; // Clear any previous errors
        } else if (result.error) {
            // Error: assign the error and clear the data
            this.error = result.error;
            this.warrantyInfo = undefined;
            this.articles = undefined;
            console.error('Error fetching case details:', result.error);
        }
    }

    // Getter to check if the data is still loading
    get isLoading() {
        return !this.wireResult;
    }

    // Getter to check if the warranty is active
    get isUnderWarranty() {
        return this.warrantyInfo && this.warrantyInfo.isUnderWarranty;
    }

    // Getter to determine the CSS class for the warranty status
    get warrantyStatusClass() {
        if (!this.warrantyInfo) {
            return 'slds-text-color_weak'; // Default text color
        }
        return this.isUnderWarranty ? 'slds-text-color_success' : 'slds-text-color_error';
    }

    // Getter to check if we have any articles to display
    get hasArticles() {
        return this.articles && this.articles.length > 0;
    }

    // Handles clicking on a knowledge article link
    handleArticleClick(event) {
        event.preventDefault(); // Stop the default link behavior
        const articleId = event.target.dataset.id;

        // Use NavigationMixin to open the article in a new console tab
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: articleId,
                objectApiName: 'KnowledgeArticleVersion',
                actionName: 'view'
            }
        });
    }
}