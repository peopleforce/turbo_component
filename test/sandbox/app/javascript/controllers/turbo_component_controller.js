import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    componentId: String,
    snapshot: String,
    snapshotJson: Object
  }

  connect() {
    this.snapshotJsonValue = JSON.parse(this.snapshotValue)
    console.log("snapshotJsonValue", this.snapshotJsonValue)
  }

  disconnect() {

  }
}
