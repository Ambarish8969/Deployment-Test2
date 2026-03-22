import { LightningElement } from 'lwc';
import getOpps from '@salesforce/apex/OpportunityController.getOpps';
import showToast from 'c/toastUtils';

const columns = [
    { label: 'Opporutnity Name', fieldName: 'Name', type: 'text' },
    {
        label: 'Stage', fieldName: 'StageName', type: 'text',
        cellAttributes: {
            class: { fieldName: 'stageClass' },
        }
    },
    { label: 'Close Date', fieldName: 'CloseDate', type: 'date' },
]

export default class OpportunityTable extends LightningElement {

    opportunities = [];
    columns = columns;

    connectedCallback() {
        this.loadOpps();
    }

    loadOpps() {
        getOpps()
            .then((result) => {
                this.opportunities = result.map(row => {
                    let stageClass = '';

                    if (row.StageName === 'Prospecting') {
                        stageClass = 'slds-text-color_warning slds-text-title_bold';
                    }
                    else if (row.StageName === 'Qualification') {
                        stageClass = 'slds-text-color_warning slds-text-title_bold';
                    }
                    else if (row.StageName === 'Closed Won') {
                        stageClass = 'slds-text-color_success slds-text-title_bold';
                    }
                    else if (row.StageName === 'Closed Lost') {
                        stageClass = 'slds-text-color_error slds-text-title_bold';
                    }
                    return { ...row, stageClass };
                });

            })
            .catch((error) => {
                showToast(this, 'Error', error.body.message, 'error');
            })
    }
}