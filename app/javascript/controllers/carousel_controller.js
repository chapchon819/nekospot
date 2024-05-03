import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["item", "container"];

  connect() {
    this.index = 0;
    this.showCurrentSlide();
  }

  next() {
    this.index = (this.index + 1) % this.itemTargets.length;
    this.showCurrentSlide();
  }

  prev() {
    this.index = (this.index - 1 + this.itemTargets.length) % this.itemTargets.length;
    this.showCurrentSlide();
  }

  showCurrentSlide() {
    const offset = this.index * -100;
    this.containerTarget.style.transform = `translateX(${offset}%)`;
  }
}