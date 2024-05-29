import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="login-modal"
export default class extends Controller {
  static targets = ["dialog", "backGround"]

  connect() {
    console.log("login-modal controller connected")
  }

  openModal() {
    console.log("openModal called")
    this.backGroundTarget.classList.remove("hidden")
    this.dialogTarget.classList.remove("hidden")
    this.dialogTarget.showModal()
  }

  // モーダルを閉じる
closeModal() {
  this.backGroundTarget.classList.add("hidden")
  this.dialogTarget.classList.add("hidden")
  this.dialogTarget.close()
}
}
