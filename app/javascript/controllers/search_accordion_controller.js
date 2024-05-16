import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["panel"];

  connect() {
    this.panelTarget.style.maxHeight = "0px"; // 初期状態を閉じた状態に
  }

  toggle() {
    const panel = this.panelTarget;
    if (panel.style.maxHeight && panel.style.maxHeight !== "0px") {
      panel.style.maxHeight = "0px";
    } else {
      panel.style.maxHeight = `${panel.scrollHeight}px`;
    }
  }

  close() {
    this.panelTarget.style.maxHeight = "0px";
  }
}