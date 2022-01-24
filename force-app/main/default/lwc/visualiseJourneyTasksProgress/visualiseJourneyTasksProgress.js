import { LightningElement, api, wire} from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getJourneyTasks from "@salesforce/apex/bg_JourneyController.getJourneyTasks";
import NAME from "@salesforce/schema/JourneyTask__c.Name";
import COMPLETION_STATUS from "@salesforce/schema/JourneyTask__c.CompletionStatus__c";
import ESTIMATED_COMPLETION_DATE from "@salesforce/schema/JourneyTask__c.EstimatedCompletionDate__c";
import dataErrorMessage from '@salesforce/label/c.Get_Data_Error_Message';
import noTasksMessage from '@salesforce/label/c.No_Tasks_Available';
import journeyTasksProgressCardTitle from '@salesforce/label/c.Journey_Tasks_Progress';
import errorOccurred from '@salesforce/label/c.Error_Occurred_Msg';
import taskColumnTitle from '@salesforce/label/c.Datatable_Label_Task';
import estimatedComplDateColumnTitle from '@salesforce/label/c.Datatable_Label_Estimated_Completion_Date';
import statusColumnTitle from '@salesforce/label/c.Datatable_Label_Status';

const COLUMNS = [
  { label: taskColumnTitle, fieldName: NAME.fieldApiName },
  {
    label: estimatedComplDateColumnTitle,
    fieldName: ESTIMATED_COMPLETION_DATE.fieldApiName
  },
  {
    label: statusColumnTitle,
    fieldName: COMPLETION_STATUS.fieldApiName,
    cellAttributes: { class: { fieldName: "completionStatus" } }
  }
];

export default class VisualiseJourneyTasksProgress extends LightningElement {
  @api recordId;
  columns = COLUMNS;
  label = {
    dataErrorMessage,
    noTasksMessage,
    journeyTasksProgressCardTitle,
    errorOccurred
  }
  hide = true;
  copyJourneyTasks;
  percentage;
  journeyTasks;
  error;
  @wire(getJourneyTasks, { journeyId: "$recordId" })
  handleJourneyTasks({ data, error }) {
    if (data === null) {
      this.hide = false;
    } 
    else if (data) {
      this.copyJourneyTasks = data;
      let completedJourneyTasksCount = 0;
      let percentageOfCompletedTasks;
      for (let i = 0; i < this.copyJourneyTasks.length; i++) {
        if (this.copyJourneyTasks[i].CompletionStatus__c === "Complete") {
          completedJourneyTasksCount += 1;
        }
      }
      percentageOfCompletedTasks = (completedJourneyTasksCount/this.copyJourneyTasks.length)*100;
      this.percentage = Math.ceil(percentageOfCompletedTasks);

      this.journeyTasks = data
        .map((item) => {
          let changeColorByStatus =
            item.CompletionStatus__c === "Complete"
              ? "slds-theme_success slds-text-color_default"
              : item.CompletionStatus__c === "In Progress"
              ? "slds-theme_warning slds-text-color_default"
              : item.CompletionStatus__c === "Overdue"
              ? "slds-theme_error slds-text-color_default"
              : "slds-theme_default slds-text-color_default";
          return { ...item, completionStatus: changeColorByStatus };
        })
        .sort(function (a, b) {
          let x = a.CompletionStatus__c.toLowerCase();
          let y = b.CompletionStatus__c.toLowerCase();
          if (x < y) {
            return -1;
          }
          if (x > y) {
            return 1;
          }
          return 0;
        })
        .reverse();
    }
    else if (error) {
      this.error = error;
      this.dispatchEvent(
        new ShowToastEvent({
          title: this.label.errorOccurred,
          message: error.body.message,
          variant: "error"
        })
      );
    }
  }
  
}
