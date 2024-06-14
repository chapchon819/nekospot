import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "answer", "answers"]

  connect() {
    this.selectedAnswerId = null;
  }

  selectAnswer(event) {
    this.clearSelections();
    const answerElement = event.currentTarget;
    answerElement.classList.add("bg-selected"); // Add your selected color class here
    this.selectedAnswerId = answerElement.dataset.id;
    answerElement.querySelector("input[type='radio']").checked = true;
  }

  clearSelections() {
    this.answerTargets.forEach(target => {
      target.classList.remove("bg-primary-hover"); // Remove your selected color class here
    });
  }


  handleSuccess(event) {
    const [data, status, xhr] = event.detail;
    this.questionContainerTarget.innerHTML = xhr.responseText;  // 次の質問または結果を表示
  }

  handleError(event) {
    alert("エラーが発生しました。もう一度お試しください。");
  }
}