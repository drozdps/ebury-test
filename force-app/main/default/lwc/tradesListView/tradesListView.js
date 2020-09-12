import { LightningElement ,api, wire, track} from 'lwc';
import getList from '@salesforce/apex/TradesController.getList';
import { refreshApex } from '@salesforce/apex';

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
            sortable: false,
            typeAttributes: {
                day: 'numeric',
                month: 'numeric',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
              },
        }
    ];
 
    error;
    tradesList;
    wiredResult;

    @wire(getList) 
    wiredTrades(result) {
        this.wiredResult = result;
        if (result.data) {
            this.tradesList = result.data;
        } else if (result.error) {
            this.error = result.error;
            this.tradesList = [];
        }
    }

    handleCancelClick() {
        this.template.querySelector('c-generic-modal').hide();
        refreshApex(this.wiredResult);
    }

    handleOpenModal() {
        this.template.querySelector('c-generic-modal').show();
    }
}