import { LightningElement, api } from 'lwc';

export default class DiscountCalculator extends LightningElement {

    @api amount;
    @api discount;
    @api finalAmount;

    handleAmount(event){
        this.amount = event.target.value;
    }

    handleDiscount(event){
        this.discount = event.target.value;
    }

    calculate(){
        if(this.amount && this.discount){
            this.finalAmount = this.amount - (this.amount * this.discount / 100);
        }
    }

}