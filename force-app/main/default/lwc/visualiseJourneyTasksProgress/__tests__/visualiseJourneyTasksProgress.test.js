import { createElement } from "lwc";
import VisualiseJourneyTasksProgress from "c/visualiseJourneyTasksProgress";
import getJourneyTasks from "@salesforce/apex/bg_JourneyController.getJourneyTasks";
import dataErrorMessage from '@salesforce/label/c.Get_Data_Error_Message';
import noTasksMessage from '@salesforce/label/c.No_Tasks_Available';

const mockGetJourneyTasks = require("./data/getJourneyTasks.json");
const mockGetJourneyTasksWithNoTasksAvailable = require("./data/getJourneyTasksWithNoTasksAvailable.json");
const label = {
  dataErrorMessage,
  noTasksMessage,
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

describe("c-visualise-journey-tasks-progress", () => {
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
      const element = createElement("c-visualise-journey-tasks-progress", {
        is: VisualiseJourneyTasksProgress
      });
      document.body.appendChild(element);

      getJourneyTasks.emit(mockGetJourneyTasks);

      await flushPromises();

      const detail = element.shadowRoot.querySelector("lightning-datatable");
      expect(detail.data.length).toBe(mockGetJourneyTasks.length);
    });

    it("checks behavior when there are no Journey Tasks", async () => {
      const element = createElement("c-visualise-journey-tasks-progress", {
        is: VisualiseJourneyTasksProgress
      });
      document.body.appendChild(element);

      getJourneyTasks.emit(mockGetJourneyTasksWithNoTasksAvailable);

      await flushPromises();

      const detail = element.shadowRoot.querySelector("lightning-datatable");
      expect(detail.data).toStrictEqual([]);
    });

    it("checks behaviour when @wire fails to return data", async () => {
      const element = createElement("c-visualise-journey-tasks-progress", {
        is: VisualiseJourneyTasksProgress
      });
      document.body.appendChild(element);

      getJourneyTasks.error();

      await flushPromises();

      const detail = element.shadowRoot.querySelectorAll("lightning-formatted-text");
      expect(detail[0].value).toBe(label.dataErrorMessage);
    });

    it("checks whether valid message is displayed when there are no Tasks", async () => {
      const element = createElement("c-visualise-journey-tasks-progress", {
        is: VisualiseJourneyTasksProgress
      });
      document.body.appendChild(element);

      getJourneyTasks.emit(null);

      await flushPromises();

      const detail = element.shadowRoot.querySelectorAll("lightning-formatted-text");
      expect(detail[0].value).toBe(label.noTasksMessage);
    });
  });
});
