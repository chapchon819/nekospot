import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["panel", "sidebar"];

  connect() {
    if (window.innerWidth >= 768) { // PCの場合
      this.panelTarget.style.maxHeight = "0px"; // 初期状態を閉じた状態に
    } else { // スマホの場合
      this.closePanel(); // 初期状態でパネルを閉じる
    }
  }

  toggle() {
    if (window.innerWidth >= 768) { // PCの場合
      const panel = this.panelTarget;
      if (panel.style.maxHeight && panel.style.maxHeight !== "0px") {
        this.closePanel();
      } else {
        this.openPanel();
      }
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
    panel.style.maxHeight = `${panel.scrollHeight}px`;
  }

  closePanel() {
    const panel = this.panelTarget;
    panel.style.maxHeight = "0px";
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