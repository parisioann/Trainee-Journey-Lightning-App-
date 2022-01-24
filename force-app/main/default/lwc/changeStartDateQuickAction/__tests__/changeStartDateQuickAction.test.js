import { createElement } from 'lwc';
import ChangeStartDateQuickAction from '../changeStartDateQuickAction';
import { CloseScreenEventName } from 'lightning/actions';

describe('c-changeStartDateQuickAction', () => {
    afterEach(() => {
        while(document.body.firstChild){
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('Test close screen on Cancel', async () => {
        const element = createElement('c-changeStartDateQuickAction', {
            is: ChangeStartDateQuickAction
        });
        document.body.appendChild(element);
        const handler = jest.fn();
        element.addEventListener(CloseScreenEventName, handler);
        const inputEl = element.shadowRoot.querySelectorAll('lightning-button');
        inputEl[0].click();
        expect(handler).toHaveBeenCalled();
    });

})

