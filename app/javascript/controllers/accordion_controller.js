import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["body", "icon"]

  connect() {
    // 初期状態で全てのaccordion-bodyを閉じる
    this.bodyTargets.forEach((body) => {
      body.style.maxHeight = "0px";
    });
  }

  toggle(event) {
    const header = event.currentTarget;
    const body = header.nextElementSibling;
    const icon = header.querySelector(".toggle-icon");

    // 他のすべてのaccordion-bodyを閉じる
    this.bodyTargets.forEach((el) => {
      if (el !== body) {
        el.style.maxHeight = "0px"; // 閉じる
      }
    });

    // 他のすべてのアイコンをph-plusに切り替え、回転をリセット
    this.iconTargets.forEach((el) => {
      if (el !== icon) {
        el.classList.remove('ph-minus');
        el.classList.add('ph-plus');
        el.classList.remove('rotate-180');
      }
    });

    // アコーディオンの状態を切り替え
    if (body.style.maxHeight !== "0px") {
      icon.classList.remove('ph-minus');
      icon.classList.add('ph-plus');
      body.style.maxHeight = "0px";
      icon.classList.remove('rotate-180');
    } else {
      icon.classList.remove('ph-plus');
      icon.classList.add('ph-minus');
      body.style.maxHeight = `${body.scrollHeight}px`;
      icon.classList.add('rotate-180');
    }
  }
}