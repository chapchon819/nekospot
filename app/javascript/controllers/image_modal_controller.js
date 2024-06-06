import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-modal"
export default class extends Controller {
  static targets = ["imageModal", "image"]

  connect() {
    this.hideModal();
    console.log("image-modal connected");
  }

  open(event) {
    event.preventDefault();
    console.log("image-modal open called");
    const imageUrl = event.currentTarget.dataset.imageUrl;
    this.imageTarget.src = imageUrl;
    this.showModal();
  }

  close(event) {
    console.log("image-modal close called");
    this.hideModal();
  }

  showModal() {
    this.imageModalTarget.classList.remove("hidden");
  }

  hideModal() {
    this.imageModalTarget.classList.add("hidden");
  }
}
