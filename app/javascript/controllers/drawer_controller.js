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

    // Drawer open events
    this.drawer.addEventListener('show.bs.drawer', () => {
      this.showBackdrop();
    });

    // Drawer close events
    this.drawer.addEventListener('hidden.bs.drawer', () => {
      this.hideBackdrop();
    });

    // Handling swipe or any other transition that triggers open/close
    this.drawer.addEventListener('transitionend', (event) => {
      if (event.propertyName === 'transform') {
        if (this.drawer.classList.contains('translate-y-full')) {
          this.hideBackdrop();
        } else {
          this.showBackdrop();
        }
      }
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

      // Add event listener to close the drawer when the backdrop is clicked
      this.backdrop.addEventListener('click', () => {
        this.drawer.classList.add('translate-y-full');
        this.hideBackdrop();
      });
    }
  }

  removeBackdrop() {
    if (this.backdrop) {
      document.body.removeChild(this.backdrop);
      this.backdrop = null;
    }
  }
}