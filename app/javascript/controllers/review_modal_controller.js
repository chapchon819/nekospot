import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review-modal"
export default class extends Controller {
    // コントローラーがHTML要素にアタッチされた時（=HTML要素が画面に表示された時）に実行される
  connect() {
    // モーダル生成
    this.modal = new Modal(this.element)
    // モーダルを表示する
    this.modal.show()
  }
  
}
