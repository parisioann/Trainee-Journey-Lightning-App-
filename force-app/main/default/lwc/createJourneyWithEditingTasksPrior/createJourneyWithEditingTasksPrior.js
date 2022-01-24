import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getJourneyTasks from "@salesforce/apex/bg_JourneyController.getJourneyTasks";
import { NavigationMixin } from 'lightning/navigation';
import editTasksCmpInstructions from '@salesforce/label/c.Edit_Journey_Tasks_Cmp_Instructions';
import dataErrorMessage from '@salesforce/label/c.Get_Data_Error_Message';
import noTasksMessage from '@salesforce/label/c.No_Tasks_Available';
import editTasksCardTitle from '@salesforce/label/c.Edit_Tasks_Card_Title';
import journeyPageBtn from '@salesforce/label/c.Journey_Page_Button_Label';
import updateTaskBtn from '@salesforce/label/c.Update_Task_Button_Label';
import errorOccurred from '@salesforce/label/c.Error_Occurred_Msg';
import taskUpdated from '@salesforce/label/c.Updated_Task_Msg';
import JOURNEY_TASK from "@salesforce/schema/JourneyTask__c";

export default class CreateJourneyWithEditingTasksPrior extends NavigationMixin(LightningElement) {
    objectApiName = JOURNEY_TASK;
    label = {
        editTasksCmpInstructions,
      dataErrorMessage,
      noTasksMessage,
      editTasksCardTitle,
      journeyPageBtn,
      updateTaskBtn,
      errorOccurred,
      taskUpdated
    }
    @api journey;
    journeyTasks;
    error;
    hide = true;
    @wire(getJourneyTasks, { journeyId: "$journey" })
    handleJourneyTasks({ data, error }) {
      if (data) {
        this.journeyTasks = data;
      } 
      if (data == "") {
        this.hide = false;
      }
      if (error) {
        this.error = error;
        this.dispatchEvent(
          new ShowToastEvent({
            title: this.label.errorOccurred,
            message: error.body.message,
            variant: 'error'
          })
        );
      }
    }

    handleSuccess(){
      const toastEvent = new ShowToastEvent({
        title: this.label.taskUpdated,
        variant: "success"
      });
      this.dispatchEvent(toastEvent);
    }

    handleError(event){
      const toastEvent = new ShowToastEvent({
          title: this.label.errorOccurred,
          message: event.detail,
          variant: "error"
        });
        this.dispatchEvent(toastEvent);
    }
    
    handleClick() {
      this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.journey,
            objectApiName: 'Journey__c',
            actionName: 'view'
        },
      });
    }

}