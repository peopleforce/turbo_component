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

        this.element.querySelectorAll('[data-turbo-action]').forEach((element) => {
            const turboAction = element.getAttribute('data-turbo-action')
            modelAttributes[attributeName] = element.value
        })
    }

    async handle(event) {
        let action = event.params.action;
        let args= []
        if (action.includes('(') && action.includes(')')) {
            // replace all double spaces with single space
            action = action.replaceAll('  ', ' ')
            action = action.replaceAll(', ', ',')
            args = action.substring(action.indexOf('(') + 1, action.indexOf(')')).split(',')
            action = action.substring(0, action.indexOf('('))
        }

        // cast args as ints if they are ints
        args = args.map((arg) => {
            if (!isNaN(arg)) {
                return parseInt(arg)
            } else if(arg === 'true') {
                return true
            } else if(arg === 'false') {
                return false
            } else if(arg === 'null') {
                return null
            } else {
                return arg.replaceAll("'", "")
            }
            return arg
        })

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
            component_action_args: args,
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
