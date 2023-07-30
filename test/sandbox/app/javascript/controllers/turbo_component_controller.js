import {Controller} from "@hotwired/stimulus"
import {FetchRequest} from '@rails/request.js'

export default class extends Controller {
    static values = {
        componentId: String,
        componentName: String,
        snapshot: String,
        snapshotJson: Object
    }

    connect() {
        this.snapshotJsonValue = JSON.parse(this.snapshotValue)
    }

    async handle(event) {
        const action = event.params.action;

        // get all model binded attributes
        let modelAttributes = {}
        this.element.querySelectorAll('[data-turbo-component-model]').forEach((element) => {
            const attributeName = element.getAttribute('data-turbo-component-model')
            modelAttributes[attributeName] = element.value
        })

        let data = {
            component_name: this.componentNameValue,
            component_id: this.componentIdValue,
            component_action: action,
            component_action_params: event.params.actionParams || [],
            snapshot: this.snapshotJsonValue,
            updates: modelAttributes
        }

        const request = new FetchRequest('post', '/turbo_actions/update', {
            body: JSON.stringify(data),
            responseKind: "turbo-stream"
        })

        const response = await request.perform()
        if (response.ok) {
            const body = await response.text
            // Do whatever do you want with the response body
            // You also are able to call `response.html` or `response.json`, be aware that if you call `response.json` and the response contentType isn't `application/json` there will be raised an error.
        }
    }

    disconnect() {

    }

    // catch all actions
}
