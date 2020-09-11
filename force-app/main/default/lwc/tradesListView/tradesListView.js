import { LightningElement ,api, wire, track} from 'lwc';
import getList from '@salesforce/apex/TradesController.getList';
export default class LightningDatatableLWCExample extends LightningElement {

    columns = [{
            label: 'Sell CCY',
            fieldName: 'SellCurrency__c',
            type: 'text',
            sortable: false
        },
        {
            label: 'Sell Amount',
            fieldName: 'SellAmount__c',
            type: 'Currency',
            sortable: false
        },
        {
            label: 'Buy CCY',
            fieldName: 'BuyCurrency__c',
            type: 'Currency',
            sortable: false
        },
        {
            label: 'Buy Amount',
            fieldName: 'BuyAmount__c',
            type: 'Currency',
            sortable: false
        },
        {
            label: 'Rate',
            fieldName: 'Rate__c',
            type: 'number',
            sortable: false
        },
        {
            label: 'Date Booked',
            fieldName: 'DateBooked__c',
            type: 'date',
            sortable: false
        }
    ];
 
    error;
    tradesList;
    defaultSortDirection = 'desc';
    sortDirection = 'asc';
    sortedBy = 'DateBooked__c';

    @wire(getList) 
    wiredTrades({error, data}) {
        if (data) {
            this.tradesList = data;
        } else if (error) {
            this.error = error;
        }
    }

    handleCancelClick() {
        this.template.querySelector('c-generic-modal').hide();
    }

    handleOpenModal() {
        this.template.querySelector('c-generic-modal').show();
    }
}