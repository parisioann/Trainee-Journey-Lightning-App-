import { createElement } from "lwc";
import { getNavigateCalledWith } from 'lightning/navigation';
import CreateJourneyWithEditingTasksPrior from "c/createJourneyWithEditingTasksPrior";
import getJourneyTasks from "@salesforce/apex/bg_JourneyController.getJourneyTasks";
import dataErrorMessage from '@salesforce/label/c.Get_Data_Error_Message';
import noTasksMessage from '@salesforce/label/c.No_Tasks_Available';
import journeyPageBtn from '@salesforce/label/c.Journey_Page_Button_Label';

const mockGetJourneyTasks = require("./data/getJourneyTasks.json");
const mockGetJourneyTasksWithNoTasksAvailable = require("./data/getJourneyTasksWithNoTasksAvailable.json");
const label = {
  dataErrorMessage,
  noTasksMessage,
  journeyPageBtn
}

jest.mock(
  "@salesforce/apex/bg_JourneyController.getJourneyTasks",
  () => {
    const { createApexTestWireAdapter } = require("@salesforce/sfdx-lwc-jest");
    return {
      default: createApexTestWireAdapter(jest.fn())
    };
  },
  { virtual: true }
);

describe("c-create-journey-with-editing-tasks-prior", () => {
    afterEach(() => {
      while (document.body.firstChild) {
        document.body.removeChild(document.body.firstChild);
      }
      jest.clearAllMocks();
    });
  
    async function flushPromises() {
      return Promise.resolve();
    }

    describe("getJourneyTasks @wire", () => {
        it("checks if the correct number of journey tasks have been returned", async () => {
          const element = createElement("c-create-journey-with-editing-tasks-prior", {
            is: CreateJourneyWithEditingTasksPrior
          });
          document.body.appendChild(element);
          
          getJourneyTasks.emit(mockGetJourneyTasks);
    
          await flushPromises();
    
          const detail = element.shadowRoot.querySelectorAll("lightning-record-edit-form");
          expect(detail.length).toBe(mockGetJourneyTasks.length);
        });
        it("checks behavior when there are no Journey Tasks", async () => {
          const element = createElement("c-create-journey-with-editing-tasks-prior", {
            is: CreateJourneyWithEditingTasksPrior
          });
          document.body.appendChild(element);
    
          getJourneyTasks.emit(mockGetJourneyTasksWithNoTasksAvailable);
    
          await flushPromises();
    
          const detail = element.shadowRoot.querySelector("lightning-record-edit-form");
          expect(detail).toBe(null);
        });
        it("checks behaviour when apex method fails to return data", async () => {
          const element = createElement("c-create-journey-with-editing-tasks-prior", {
            is: CreateJourneyWithEditingTasksPrior
          });
          document.body.appendChild(element);
    
          getJourneyTasks.error();
    
          await flushPromises();
    
          const detail = element.shadowRoot.querySelectorAll("lightning-formatted-text");
          expect(detail[0].value).toBe(label.dataErrorMessage);
        });
        it("checks whether valid message is displayed when there are no Tasks", async () => {
          const element = createElement("c-create-journey-with-editing-tasks-prior", {
            is: CreateJourneyWithEditingTasksPrior
          });
          document.body.appendChild(element);
    
          getJourneyTasks.emit("");
    
          await flushPromises();
    
          const detail = element.shadowRoot.querySelectorAll("lightning-formatted-text");
          expect(detail[0].value).toBe(label.noTasksMessage);
        });
        it("checks whether button re-directs to the appropriate record page", async () => {
          const NAV_TYPE = 'standard__recordPage';
          const NAV_OBJECT_API_NAME = 'Journey__c';
          const NAV_ACTION_NAME = 'view';
          const NAV_RECORD_ID = '0031700000pJRRWAA4';

          const element = createElement("c-create-journey-with-editing-tasks-prior", {
            is: CreateJourneyWithEditingTasksPrior
          });
          element.journey = '0031700000pJRRWAA4';
          document.body.appendChild(element);
          
          await flushPromises();
    
          const buttonEl = element.shadowRoot.querySelector("lightning-button");
          buttonEl.click();

          const { pageReference } = getNavigateCalledWith();
          expect(pageReference.type).toBe(NAV_TYPE);
          expect(pageReference.attributes.objectApiName).toBe(
              NAV_OBJECT_API_NAME
          );
          expect(pageReference.attributes.actionName).toBe(NAV_ACTION_NAME);
          expect(pageReference.attributes.recordId).toBe(NAV_RECORD_ID);
          expect(buttonEl.label).toBe(label.journeyPageBtn);
        });

    });

});