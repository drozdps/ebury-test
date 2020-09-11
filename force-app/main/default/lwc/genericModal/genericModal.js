import { LightningElement, api } from 'lwc';

const CSS_HIDDEN_CLASS = 'modal-hidden';

const CSS_MODAL_CLASS = 'slds-modal slds-fade-in-open';
const CSS_MODAL_FOOTER_CLASS = 'slds-modal__footer';
const CSS_MODAL_CONTENT_CLASS = 'slds-modal__content slds-p-around_medium';

export default class GenericModal extends LightningElement {

    _modelId = new Date().getTime();
    _show = false;
    _ready = false;

    @api hideHeader;
    @api hideFooter;
    @api hideOverlay;
    @api defaultHeader;
    @api hideCloseButton;
    @api sizeClass;
    @api footerClass;
    @api contentClass;

    constructor() {
        super();
    }

    get classModal() {
        return CSS_MODAL_CLASS + ' ' + this.sizeClass;
    }

    get classModalFooter() {
        return CSS_MODAL_FOOTER_CLASS + ' ' + this.footerClass;
    }
    

    get classModalContent() {
        return CSS_MODAL_CONTENT_CLASS + ' ' + this.contentClass;
    }

    get headerTitleId() {
        return 'modal-header-title-id-' + this._modelId;
    }

    get contentId() {
        return 'modal-content-id-' + this._modelId;
    }

    @api
    show() {
        this._show = true;
        this.dispatchShowEvent();
    }

    @api
    hide() {
        this._show = false;
        this._ready = false;
        this.dispatcHideEvent();
    }

    dispatchShowEvent() {
        this.dispatchEvent(new CustomEvent('show'));
    }

    dispatcHideEvent() {
        this.dispatchEvent(new CustomEvent('hide'));
    }

    renderedCallback() {
        if (this._show && !this._ready) {
            this._ready = true;
            this.dispatchEvent(new CustomEvent('ready'));
        }
    }

    handleClose() {
        this.hide();
    }

    handleSlotTaglineChange() {}
    handleSlotContentChange() {}
    handleSlotFooterChange() {}
    handleSlotTitleChange() {}

}