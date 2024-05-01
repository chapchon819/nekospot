import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  connect() {
    this.sidebarTarget.classList.add('-translate-x-full'); // 初期状態は非表示
  }

  toggle() {
    this.sidebarTarget.classList.toggle('-translate-x-full'); // sidebarTargetを使う
  }
}
