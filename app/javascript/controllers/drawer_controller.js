import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["drawer"];

  connect() {
    this.initializeDrawer('drawer-swipe');
    this.initializeDrawer('review-drawer-swipe');
    this.initializeDrawer('no-review-drawer-swipe');
  }

  initializeDrawer(drawerId) {
    const drawer = document.getElementById(drawerId);
    if (!drawer) return;

    document.querySelectorAll(`[data-drawer-show="${drawerId}"]`).forEach(button => {
      button.addEventListener('click', () => {
        this.showBackdrop();
      });
    });

    drawer.querySelector('[data-drawer-toggle]').addEventListener('click', () => {
      this.hideBackdrop();
    });

    // Drawer open events
    drawer.addEventListener('show.bs.drawer', () => {
      this.showBackdrop();
    });

    // Drawer close events
    drawer.addEventListener('hidden.bs.drawer', () => {
      this.hideBackdrop();
    });

    // Handling swipe or any other transition that triggers open/close
    drawer.addEventListener('transitionend', (event) => {
      if (event.propertyName === 'transform') {
        if (drawer.classList.contains('translate-y-full')) {
          this.hideBackdrop();
        } else {
          this.showBackdrop();
        }
      }
    });

    // Handle form submission within the drawer
    drawer.querySelectorAll('form').forEach(form => {
      form.addEventListener('submit', () => {
        drawer.classList.add('translate-y-full');
        this.hideBackdrop();
      });
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
        document.querySelectorAll('.drawer.open').forEach(drawer => {
          drawer.classList.add('translate-y-full');
        });
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