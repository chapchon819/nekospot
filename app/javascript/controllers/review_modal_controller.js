import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review-modal"
export default class extends Controller {
  // ターゲットの定義
  static targets = ["reviewModal", "backGround", "removeImageInput", "loadingSpinner"]

  // コントローラーがHTML要素にアタッチされた時（=HTML要素が画面に表示された時）に実行される
  connect() {
    // spotIdを取得
    const spotElement = this.element.closest('[data-spot-id]')
    this.spotId = spotElement ? spotElement.dataset.spotId : null
    console.log(this.spotId) // デバッグ用のログ出力
    this.loadingSpinnerTarget.classList.add("hidden")
  }

  close(event) {
    if (event.detail.success) {
      this.backGroundTarget.classList.add("hidden")
      this.hideLoadingSpinner()
    }
  }

  // モーダルを閉じる
  closeModal() {
    this.backGroundTarget.classList.add("hidden")
    this.hideLoadingSpinner()
  }

  // モーダルの外側をクリックしたら閉じる
  closeBackground(event) {
    if (event.target == this.backGroundTarget) {
      this.closeModal()
    }
  }

  removeImage(event) {
    const index = event.target.closest("button").dataset.index
    const removeImageInput = this.removeImageInputTarget

    // 削除する画像のインデックスをインプットに追加
    const currentValue = removeImageInput.value
    removeImageInput.value = currentValue ? `${currentValue},${index}` : index

    // 画像をフォームから削除（画面上からは見えなくする）
    document.getElementById(`image-${index}`).style.display = 'none'
  }

  showLoadingSpinner() {
    this.loadingSpinnerTarget.classList.remove("hidden")
  }

  hideLoadingSpinner() {
    this.loadingSpinnerTarget.classList.add("hidden")
  }
}