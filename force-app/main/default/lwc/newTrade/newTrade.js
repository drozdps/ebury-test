import { LightningElement } from 'lwc';

export default class NewTrade extends LightningElement {
    handleChange() {
        let sellAmount = this.template.querySelector('[data-id="sellAmount"]').value;
        let sellCurrency = this.template.querySelector('[data-id="sellCurrency"]').value;
        let buyCurrency = this.template.querySelector('[data-id="buyCurrency"]').value;
        console.log('sellAmount:'+ sellAmount + ', sellCurrency:' + sellCurrency + ', buyCurrency:' + buyCurrency);
    }

    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }
}