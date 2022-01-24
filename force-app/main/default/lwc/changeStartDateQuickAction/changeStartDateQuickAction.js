import { LightningElement, api } from "lwc";
import { CloseActionScreenEvent } from "lightning/actions";
import JOURNEY_OBJECT from "@salesforce/schema/Journey__c";
import changeStartDate from '@salesforce/label/c.Change_Start_Date';
import saveBtnLabel from '@salesforce/label/c.Save_Button_Label';
import cancelBtnLabel from '@salesforce/label/c.Cancel_Button_Label';

export default class ChangeStartDateQuickAction extends LightningElement {
  objectApiName = JOURNEY_OBJECT;
  label = {
    changeStartDate,
    saveBtnLabel,
    cancelBtnLabel
  }
  @api recordId;
  recordPageUrl;

  handleCancel() {
    this.dispatchEvent(new CloseActionScreenEvent());
  }

  handleSuccess() {
    this.dispatchEvent(new CloseActionScreenEvent());
    setTimeout(() => window.location.reload(), 1000);
  }
}
