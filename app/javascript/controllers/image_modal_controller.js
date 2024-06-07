import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-modal"
export default class extends Controller {
  static targets = ["imageModal", "image", "carousel", "carouselImage"]

  connect() {
    this.hideModal();
    this.currentIndex = 0;
    console.log("image-modal connected");
  }

  open(event) {
    event.preventDefault();
    console.log("image-modal open called");

    if (this.hasCarouselTarget) {
      this.showModal();
      this.showImage(0);
    } else {
      const imageUrl = event.currentTarget.dataset.imageUrl;
      this.imageTarget.src = imageUrl;
      this.showModal();
    }
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

  next() {
    this.showImage(this.currentIndex + 1);
  }

  prev() {
    this.showImage(this.currentIndex - 1);
  }

  showImage(index) {
    if (index < 0) {
      index = this.carouselImageTargets.length - 1;
    } else if (index >= this.carouselImageTargets.length) {
      index = 0;
    }

    this.carouselImageTargets.forEach((image, i) => {
      image.classList.toggle("hidden", i !== index);
      image.classList.toggle("block", i === index);
    });

    this.currentIndex = index;
  }
}