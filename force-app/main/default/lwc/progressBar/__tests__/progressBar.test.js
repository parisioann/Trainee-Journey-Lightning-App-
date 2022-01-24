import { createElement } from "lwc";
import ProgressBar from "c/progressBar";

describe("c-progress-bar", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("checks if progress bar and percentage indication are displayed", async () => {
    const element = createElement("c-progress-bar", {
      is: ProgressBar
    });
    document.body.appendChild(element);
    const detail = element.shadowRoot.querySelector("p");
    expect(element).toBeTruthy();
    expect(detail.textContent).not.toBe(null);
  });
});
