import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "answer", "answers", "errorMessage"]

  connect() {
    this.selectedAnswerId = null;
    this.formTarget.addEventListener("submit", this.validateSubmission.bind(this));
  }

  disconnect() {
    this.formTarget.removeEventListener("submit", this.validateSubmission.bind(this));
  }

  selectAnswer(event) {
    this.clearSelections();
    const answerElement = event.currentTarget;
    answerElement.classList.add("bg-primary-hover"); // Add your selected color class here
    this.selectedAnswerId = answerElement.dataset.id;
    answerElement.querySelector("input[type='radio']").checked = true;
  }

  clearSelections() {
    this.answerTargets.forEach(target => {
      target.classList.remove("bg-selected"); // Update this to your selected color class
    });
  }

  validateSubmission(event) {
    if (!this.selectedAnswerId) {
      event.preventDefault();
      this.errorMessageTarget.classList.remove("hidden");
    } else {
      this.errorMessageTarget.classList.add("hidden");
    }
  }

  handleSuccess(event) {
    const [data, status, xhr] = event.detail;
    this.questionContainerTarget.innerHTML = xhr.responseText;  // 次の質問または結果を表示
  }

  handleError(event) {
    alert("エラーが発生しました。もう一度お試しください。");
  }
}