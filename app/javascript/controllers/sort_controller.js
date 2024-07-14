import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sort"
export default class extends Controller {
  static targets = ["sortButton", "sortOptions"]

  connect() {
    this.updateSortLabel()
  }

  updateSortLabel(event) {
    const selectedOption = event ? event.target.textContent : this.getSortLabelFromCurrentSort()
    this.sortButtonTarget.innerHTML = `
      <i class="ph-bold ph-arrows-down-up fa-2xl text-primary-hover"></i>
      <span class="text-[12px] text-secondary dark:text-gray-400 group-hover:text-neutral">${selectedOption}</span>
    `
  }

  getSortLabelFromCurrentSort() {
    const currentSort = this.sortButtonTarget.dataset.currentSort
    switch (currentSort) {
      case "rating desc":
        return "高評価"
      case "created_at desc":
        return "新着順"
      default:
        return "標準"
    }
  }
}
