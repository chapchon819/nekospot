import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "answer", "answers", "errorMessage"]

  connect() {
    //初期状態では選択された回答がないことを示す
    this.selectedAnswerId = null;
    //フォームが送信されるときにvalidateSubmissionメソッドを実行する
    this.formTarget.addEventListener("submit", this.validateSubmission.bind(this));
  }

  selectAnswer(event) { //ユーザーが回答を選択したときに呼び出される
    this.clearSelections(); //以前の選択をクリア
    const answerElement = event.currentTarget; //クリックされた要素を取得
    answerElement.classList.add("bg-primary-hover"); // 選択された回答の色を変える
    this.selectedAnswerId = answerElement.dataset.id; //選択された回答のIDを保存
    answerElement.querySelector("input[type='radio']").checked = true; //対応するラジオボタンを選択状態にする
  }

  clearSelections() {
    this.answerTargets.forEach(target => {
      target.classList.remove("bg-primary-hover"); // すべての回答の選択状態をクリア
    });
  }

  validateSubmission(event) { //フォームが送信される前に実行され、回答が選択されているかどうかを確認
    if (!this.selectedAnswerId) { //回答が選択されていない場合、
      event.preventDefault(); //フォーム送信を防ぎ
      this.errorMessageTarget.classList.remove("hidden"); //hiddenを消してエラーメッセージを表示
    } else {
      this.errorMessageTarget.classList.add("hidden"); //回答が選択されている場合、エラーメッセージを非表示にする
    }
  }

  handleSuccess(event) { //フォーム送信が成功したときに実行される
    const [data, status, xhr] = event.detail; //送信結果event.detailからdata、status、xhrを取得
    //event.detailには、送信結果に関する情報が含まれる
    //data: サーバーからのレスポンスデータ。通常はJSON形式
    //status: HTTPステータスコード
    //xhr: XMLHttpRequestオブジェクト
    this.questionContainerTarget.innerHTML = xhr.responseText;  // 次の質問または結果を表示
  }

  handleError(event) {
    alert("エラーが発生しました。もう一度お試しください。");
  }
}