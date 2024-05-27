import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.close = this.close.bind(this)
    this.handleOutsideClick = this.handleOutsideClick.bind(this)
  }

  open() {
    this.modalTarget.showModal()
    document.addEventListener("click", this.handleOutsideClick)
  }

  close() {
    this.modalTarget.close()
    document.removeEventListener("click", this.handleOutsideClick)
  }

  handleOutsideClick(event) {
    if (!this.modalTarget.contains(event.target)) {
      this.close()
    }
  }
}
