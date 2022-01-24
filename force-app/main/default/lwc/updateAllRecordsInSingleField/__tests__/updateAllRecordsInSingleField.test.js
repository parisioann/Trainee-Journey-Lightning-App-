import { createElement } from "lwc";
import UpdateAllRecordsInSingleField from "c/updateAllRecordsInSingleField";
import relativeDaysToComplete  from '@salesforce/label/c.Relative_Days_to_Complete_Field_Title';
import numBadInput from '@salesforce/label/c.Msg_for_Bad_Input_in_Numeric_Field';
import maxDaysValue from '@salesforce/label/c.Max_Days_Value';
import minDaysValue from '@salesforce/label/c.Min_Days_Value';
import daysToCompleteFieldStep from '@salesforce/label/c.Relative_Days_to_Complete_Field_Step_Size';
import updateBtn from '@salesforce/label/c.Update_Button_Label';
import relativeDaysToCompleteMassIncrementBySameAmount from "@salesforce/apex/bg_JourneyController.relativeDaysToCompleteMassIncrementBySameAmount";

const label = {
  relativeDaysToComplete,
  numBadInput,
  maxDaysValue,
  minDaysValue,
  daysToCompleteFieldStep,
  updateBtn
}

jest.mock(
  "@salesforce/apex/bg_JourneyController.relativeDaysToCompleteMassIncrementBySameAmount",
  () => {
    return {
      default: jest.fn()
    };
  },
  { virtual: true }
);

  describe("c-update-all-records-in-single-field", () => {
    afterEach(() => {
      while (document.body.firstChild) {
        document.body.removeChild(document.body.firstChild);
      }
      jest.clearAllMocks();
    });
  
    async function flushPromises() {
      return Promise.resolve();
    }

    it("check input field attributes", async () => {
        const USER_INPUT = '10';

        const element = createElement("c-update-all-records-in-single-field", {
        is: UpdateAllRecordsInSingleField
        });
        document.body.appendChild(element);
          
        await flushPromises();
          
        const input = element.shadowRoot.querySelector("lightning-input");
        input.value = USER_INPUT;
        expect(input.value).toBe(USER_INPUT);
        expect(input.messageWhenBadInput).toBe(label.numBadInput);
        expect(input.messageWhenRangeOverflow).toBe(label.maxDaysValue);
        expect(input.messageWhenRangeUnderflow).toBe(label.minDaysValue);
        expect(input.messageWhenStepMismatch).toBe(label.daysToCompleteFieldStep);
        expect(input.type).toBe('number');
        expect(input.label).toBe(label.relativeDaysToComplete);
    });
    it("check button attributes", async () => {
      const RECORD_ID = '0031700000pJRRWAA4';
      const USER_INPUT = '10';
      const APEX_PARAMETERS = { journeyId: RECORD_ID,  daysToComplete: USER_INPUT };
      relativeDaysToCompleteMassIncrementBySameAmount.mockResolvedValue(APEX_PARAMETERS);
      
      const element = createElement("c-update-all-records-in-single-field", {
      is: UpdateAllRecordsInSingleField
      });
      //element.addEventListener('click', relativeDaysToCompleteMassIncrementBySameAmount);
      document.body.appendChild(element);

      const input = element.shadowRoot.querySelector('lightning-input');
      input.value = USER_INPUT;
      input.dispatchEvent(new CustomEvent('commit'));

      const buttonEl = element.shadowRoot.querySelector("lightning-button");
      expect(buttonEl.label).toBe(label.updateBtn);
      buttonEl.click();

      await flushPromises();

      expect(relativeDaysToCompleteMassIncrementBySameAmount).toHaveBeenCalled();
  });

});