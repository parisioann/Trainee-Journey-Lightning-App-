import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import relativeDaysToCompleteMassIncrementBySameAmount from "@salesforce/apex/bg_JourneyController.relativeDaysToCompleteMassIncrementBySameAmount";
import massUpdateByField from '@salesforce/label/c.Update_All_Records_By_Field';
import relativeDaysToComplete  from '@salesforce/label/c.Relative_Days_to_Complete_Field_Title';
import updateBtn from '@salesforce/label/c.Update_Button_Label';
import numBadInput from '@salesforce/label/c.Msg_for_Bad_Input_in_Numeric_Field';
import maxDaysValue from '@salesforce/label/c.Max_Days_Value';
import minDaysValue from '@salesforce/label/c.Min_Days_Value';
import daysToCompleteFieldStep from '@salesforce/label/c.Relative_Days_to_Complete_Field_Step_Size';
import daysToCompleteFieldHelpText from '@salesforce/label/c.Relative_Days_to_Complete_Mass_Update_Help_Text';
import updateRecordsErrorMsg from '@salesforce/label/c.Error_Updating_Records_Msg';

export default class UpdateAllRecordsInSingleField extends LightningElement {
    label = {
        massUpdateByField,
        relativeDaysToComplete,
        updateBtn,
        numBadInput,
        maxDaysValue,
        minDaysValue,
        daysToCompleteFieldStep,
        daysToCompleteFieldHelpText,
        updateRecordsErrorMsg
    }
    @api journey;
    updateByNumOfDays;

    handleCommit(){
        this.updateByNumOfDays = Number(this.template.querySelector('lightning-input').value);
        relativeDaysToCompleteMassIncrementBySameAmount({ journeyId: this.journey,  daysToComplete: this.updateByNumOfDays })
        .then(() => window.location.reload())
        .catch (error=> {
            this.dispatchEvent(
              new ShowToastEvent({
                  title: this.label.updateRecordsErrorMsg,
                  message: error.body.message,
                  variant: 'error'
              })
            );
        });
    }
}