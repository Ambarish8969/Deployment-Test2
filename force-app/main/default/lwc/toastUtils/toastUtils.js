import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export function showToast(component, title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    component.dispatchEvent(event);
}