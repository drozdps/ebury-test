import { LightningElement } from 'lwc';
import getConvertResult from '@salesforce/apex/NewTradeController.getConvertResult';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class NewTrade extends LightningElement {

    sellAmount;
    buyAmount;
    rate;
    dateBooked;

    handleChange() {
        let sellAmount = this.template.querySelector('[data-id="sellAmount"]').value;
        let sellCurrency = this.template.querySelector('[data-id="sellCurrency"]').value;
        let buyCurrency = this.template.querySelector('[data-id="buyCurrency"]').value;
        console.log('sellAmount:'+ sellAmount + ', sellCurrency:' + sellCurrency + ', buyCurrency:' + buyCurrency);
        if (sellAmount && sellCurrency && buyCurrency) {
            getConvertResult({
                fromCurrency: sellCurrency, 
                toCurrency: buyCurrency, 
                amount: sellAmount
            }).then((response) => {
                this.buyAmount = response.result;
                this.rate = response.info ? response.info.rate : 'X';
                this.dateBooked = Date.now();
                // not sure whether we should use the datetime from Fixer.io (last exchange trade time)
                // this.dateBooked = response.info ? response.info.timestamp : null;
            }).catch((error) => {
                this.showNotification('Error!', error.body.message, 'error');
            });
        }
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleCreate(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Rate__c = this.rate;
        fields.ID__c = 'TR' + [...Array(7)].map(i=>(~~(Math.random()*36)).toString(36)).join('').toUpperCase();
        let sellAmount = this.template.querySelector('[data-id="sellAmount"]').value;
        if (this.dateBooked) {
            let today = new Date(this.dateBooked).toISOString();;
            fields.DateBooked__c = today;
        }
        fields.SellAmount__c = sellAmount;
        fields.BuyAmount__c = this.buyAmount;
        console.log('Fields:' + JSON.stringify(fields));
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess() {
        this.handleCancel();
        this.showNotification('Success', 'Your record was created', 'success');
    }

    handleError() {
        this.showNotification('Error!', 'Something went wrong. Contact your system administrator.', 'error');
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}