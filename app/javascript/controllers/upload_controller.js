import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload"
export default class extends Controller {
  static targets = ["input", "form", "hiddenFields"];

  async uploadFile(event) {
    event.preventDefault();

    const file = this.inputTarget.files[0];
    
    if (!file) {
      // ファイルが選択されていない場合、直接フォームを送信する
      this.formTarget.requestSubmit();
      return;
    }

    const response = await fetch('/presigned_post', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({
        filename: file.name,
        content_type: file.type,
      }),
    });

    if (!response.ok) {
      const errorData = await response.json();
      alert(`Presigned URLの取得に失敗しました: ${errorData.error}`);
      return;
    }

    const data = await response.json();

    if (!data.url || !data.fields) {
      alert('Presigned URLの形式が不正です');
      return;
    }

    const formData = new FormData();
    Object.keys(data.fields).forEach((key) => {
      formData.append(key, data.fields[key]);
    });
    formData.append('file', file);

    const uploadResponse = await fetch(data.url, {
      method: 'PUT',
      body: file,
      headers: {
        'Content-Type': file.type
      }
    });

    if (uploadResponse.ok) {
      // アップロードしたファイルのURLをフォームにセットする
      const hiddenField = document.createElement("input");
      hiddenField.setAttribute("type", "hidden");
      hiddenField.setAttribute("name", "review[uploaded_images][]");
      hiddenField.setAttribute("value", data.url + '/' + data.fields.key);
      this.hiddenFieldsTarget.appendChild(hiddenField);

      // 画像のアップロードが成功したら、フォームを送信する
      this.formTarget.requestSubmit();
    } else {
      alert('アップロードに失敗しました');
    }
  }
}