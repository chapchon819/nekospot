import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.showCurrentTab(0)  // デフォルトで最初のタブを表示
  }

  changeTab(event) {
    const index = this.tabTargets.indexOf(event.currentTarget)
    this.showCurrentTab(index)
  }

  showCurrentTab(index) {
    this.tabTargets.forEach((tab, idx) => {
      if (index === idx) {
        tab.classList.remove('text-gray-500', 'border-transparent');
        tab.classList.add('text-blue-700', 'border-blue-500');
      } else {
        tab.classList.remove('text-blue-700', 'border-blue-500');
        tab.classList.add('text-gray-500', 'border-transparent');
      }
    });
    this.panelTargets.forEach((panel, idx) => {
      panel.classList.toggle("hidden", index !== idx)
    })
  }
}