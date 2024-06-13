import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "Container"];

  connect() {
    this.formTarget.addEventListener("ajax:success", this.handleSuccess.bind(this));
    this.formTarget.addEventListener("ajax:error", this.handleError.bind(this));
  }

  handleSuccess(event) {
    const [data, status, xhr] = event.detail;
    this.questionContainerTarget.innerHTML = xhr.responseText;  // 次の質問または結果を表示
  }

  handleError(event) {
    alert("エラーが発生しました。もう一度お試しください。");
  }
}