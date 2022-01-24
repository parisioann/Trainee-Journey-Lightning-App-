import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import JOURNEY_OBJECT from '@salesforce/schema/Journey__c';
import createNewJourney from '@salesforce/label/c.Create_New_Journey';
import saveEditTasksBtnLabel from '@salesforce/label/c.Save_Edit_Tasks';
import saveGoToJourneyBtnLabel from '@salesforce/label/c.Save_Go_To_Journey_Page_Button_Label';
import cancelBtnLabel from '@salesforce/label/c.Cancel_Button_Label';
import journeyCreatedSuccess from '@salesforce/label/c.Journey_Creation_Success_Message';

export default class CreateJourneyFromTemplatePageQuickAction extends NavigationMixin(LightningElement) {
    objectApiName = JOURNEY_OBJECT;
    label = {
        createNewJourney,
        saveEditTasksBtnLabel,
        saveGoToJourneyBtnLabel,
        cancelBtnLabel
    }
    @api recordId;
    getEditName;

    processEdit(event){
        this.getEditName = event.target.getAttribute('data-name');
    }

    handleSuccess(event) {  
        if (this.getEditName === 'edit'){
            const newJourneyId = event.detail.id;
            const castIdToString = String(newJourneyId);
            this[NavigationMixin.Navigate]({
                type: 'standard__component',
                attributes: {
                    componentName: "c__createJourneyWithEditCmpHolder"
                },
                state: {
                    c__journey: castIdToString
                }
            });
        }else {
            const toastEvent = new ShowToastEvent({
                title: journeyCreatedSuccess,
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
            
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    actionName: 'view',
                },
            });
        }     
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
        
}