import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["panel", "sidebar"];

  connect() {
    this.closePanel(); // 初期状態でパネルを閉じる
  }

  toggle() {
    if (window.innerWidth >= 768) { // PCの場合
      this.toggleAccordion();
    } else { // スマホの場合
      this.openSidebar();
    }
  }

  toggleAccordion() {
    const panel = this.panelTarget;
    if (panel.classList.contains('h-0')) {
      panel.classList.remove('h-0', 'opacity-0', 'invisible');
      panel.classList.add('h-auto', 'opacity-100', 'visible');
    } else {
      this.closePanel();
    }
  }

  openPanel() {
    const panel = this.panelTarget;
    panel.classList.remove('h-0', 'opacity-0', 'invisible');
    panel.classList.add('h-auto', 'opacity-100', 'visible');
  }

  closePanel() {
    const panel = this.panelTarget;
    panel.classList.remove('h-auto', 'opacity-100', 'visible');
    panel.classList.add('h-0', 'opacity-0', 'invisible');
  }

  openSidebar() {
    this.sidebarTarget.style.display = "flex";
  }

  closeSidebar() {
    this.sidebarTarget.style.display = "none";
  }

  close() {
    this.closePanel();
  }
}