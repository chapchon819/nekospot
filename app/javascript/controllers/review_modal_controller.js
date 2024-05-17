import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review-modal"
export default class extends Controller {
    //ターゲットの定義
  static targets = ["reviewModal", "backGround"]
    // コントローラーがHTML要素にアタッチされた時（=HTML要素が画面に表示された時）に実行される
  connect() {
  }
  close(event) {
    if (event.detail.success) {
      this.backGroundTarget.classList.add("hidden")
  }
}
// モーダルを閉じる
closeModal() {
  this.backGroundTarget.classList.add("hidden")
}

// モーダルの外側をクリックしたら閉じる
closeBackground(event) {
  if(event.target == this.backGroundTarget) {
    this.closeModal();
  }
}
}
