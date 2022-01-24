import { createElement } from "lwc";
import CreateJourneyfromTemplatepageButton from "../createJourneyFromTemplatePageQuickAction";
import { CloseScreenEventName } from "lightning/actions";
import JOURNEY_OBJECT from '@salesforce/schema/Journey__c';


describe("c-createJourneyFromTemplatePageQuickAction", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("renders lightning-record-edit-form", () => {

    const element = createElement(
      "c-createJourneyFromTemplatePageQuickAction",
      { is: CreateJourneyfromTemplatepageButton }
    );
    document.body.appendChild(element);

    const form = element.shadowRoot.querySelector("lightning-record-edit-form");
    expect(form.objectApiName).toEqual(JOURNEY_OBJECT);
  });

  it("Test close screen on Cancel", async () => {
    const element = createElement(
      "c-createJourneyFromTemplatePageQuickAction",
      {
        is: CreateJourneyfromTemplatepageButton
      }
    );
    document.body.appendChild(element);
    const handler = jest.fn();
    element.addEventListener(CloseScreenEventName, handler);
    const inputEl = element.shadowRoot.querySelectorAll("lightning-button");
    inputEl[0].click();
    expect(handler).toHaveBeenCalled();
  });
});
