import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="radio-tags"
export default class extends Controller {
  static targets = ["tag"]

  connect() {
    this.selectedClasses = ["bg-secondary", "text-white"] // Tailwind classes for selected state
  }

  select(event) {
    event.preventDefault()
    this.tagTargets.forEach(tag => {
      this.selectedClasses.forEach(cls => tag.classList.remove(cls))
    })
    const tagElement = event.currentTarget
    this.selectedClasses.forEach(cls => tagElement.classList.add(cls))
    const radioInput = tagElement.querySelector("input[type='radio']")
    if (radioInput) {
      radioInput.checked = true
      radioInput.dispatchEvent(new Event("change")) // 追加: changeイベントを手動で発火
    }
  }
}