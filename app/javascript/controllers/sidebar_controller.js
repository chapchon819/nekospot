import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "icon", "buttonText", "toggleButton"]

  connect() {
    this.sidebarTarget.classList.add('-translate-x-full'); // 初期状態は非表示
    this.toggleButtonTarget.dataset.state = "list"; // 初期状態をリストとして設定
  }

  toggleButton() {
    this.sidebarTarget.classList.toggle('-translate-x-full');

    // ボタンの状態に応じてアイコンとテキストを変更
    if (this.toggleButtonTarget.dataset.state === "list") {
      this.iconTarget.className = "ph-fill ph-map-pin";
      this.buttonTextTarget.textContent = "マップ";
      this.toggleButtonTarget.dataset.state = "map";
    } else {
      this.iconTarget.className = "ph-bold ph-list-dashes";
      this.buttonTextTarget.textContent = "リスト";
      this.toggleButtonTarget.dataset.state = "list";
    }
  }
}
