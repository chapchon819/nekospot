import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["drawer"];

  connect() {
    this.drawer = document.getElementById('drawer-swipe');
    document.querySelectorAll('[data-drawer-show]').forEach(button => {
      button.addEventListener('click', () => {
        this.showBackdrop();
      });
    });
    this.drawer.querySelector('[data-drawer-toggle]').addEventListener('click', () => {
      this.hideBackdrop();
    });
  }

  showBackdrop() {
    this.createBackdrop();
  }

  hideBackdrop() {
    this.removeBackdrop();
  }

  createBackdrop() {
    if (!this.backdrop) {
      this.backdrop = document.createElement('div');
      this.backdrop.className = 'fixed inset-0 bg-black bg-opacity-50 z-30';
      document.body.appendChild(this.backdrop);
    }
  }

  removeBackdrop() {
    if (this.backdrop) {
      document.body.removeChild(this.backdrop);
      this.backdrop = null;
    }
  }
}