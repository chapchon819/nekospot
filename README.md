## 🐈 アプリ名：NekoSpot
## 🐈 サービス概要
猫と出会える・触れ合えるスポットやイベント情報を検索・シェアできるアプリです。現在地・地域、カテゴリーから検索することができます。スポット詳細ページに関連タグで取得したInstagram投稿を埋め込むことで見るだけでも楽しめるようにします。また、猫スポットやイベントをお気に入りに登録するとカレンダーに登録され、LINEでリマインドと行った後のレビュー依頼通知をしてくれます。（猫スポットの場合は日時の指定が必要）レビューが溜まってきたらレビューから検索やレコメンドできるようにしたいです。みんなの猫スポットには道で出会った猫などの写真と場所を投稿し楽しむこともできます。
## 🐈 このサービスへの思い・作りたい理由
私にとって猫はとても尊い存在です。しかし、ペット不可の賃貸に住んでいるため猫を飼うことができません。猫と触れ合う機会を作るため、猫と触れ合えるスポットやイベントの情報収集をする際に、猫カフェはGoogleMapから検索しやすいですが、その他のスポットやイベントなどは一元化されたアプリやサイトがないことに気付きました。それなら自分で作ってしまおうと思ったのが発案のきっかけです。全国の猫好きの皆さんのQOLを少しでも向上させたいです。
## 🐈 ユーザー層について
- 猫や動物が好きな人
- 猫とふれあいたい人
## 🐈 サービスの利用イメージ
- 現在地・地域、カテゴリーから猫スポットを検索することができる
- 行きたい猫スポットやイベントをシェアすることができる
- 猫スポットやイベントをお気に入りに登録するとカレンダーに表示され、リマインドや訪問済コレクションとして活用することができる。
- 日時を指定してお気に入りに登録すると、行く前のリマインドと行った後のレビュー依頼通知がLINEで送信される。
- レビューでの評価などから猫スポットがリコメンドされる
- みんなの猫スポットで、日常で出会った猫を共有することもできる
## 🐈 ユーザーの獲得について
- Xシェア
- Qiitaで技術記事執筆
## 🐈 サービスの差別化ポイント・推しポイント
- 猫カフェはGoogleMapから検索可能ですが、細かなレビューや関連するInstagram投稿を取得し写真を表示させることでスポットでの体験をより想像しやすくする
- 猫カフェ以外の猫と触れ合えるスポットはGoogle検索やInstagramからでは、猫と触れ合えるスポット以外も表示されるため求めている情報の取得が難しい。
- 「猫カフェ」などのキーワードからのスポット検索ではある程度ヒットするが、「兵庫県」など場所から猫スポットを絞り込むことはできない。
- イベントや猫スポットはネット検索でも取得できるが、情報が点在しているため、それを一元化させることで検索をスムーズにする。
## 🐈 機能候補
### MVPリリース
- LINEログイン
- Google Places APIでスポット詳細情報の取得・表示（あらかじめDBに保存しておく）
- Google Maps JavaScript APIで地図表示
- Google Geolocation APIで現在地周辺の猫スポットを取得
- 検索機能（カテゴリー・地域から）
- スポット詳細表示
  - Instagram graph APIで関連投稿を取得し表示させる
- お気に入り登録機能
  - リスト登録
  - 日時を指定してMyカレンダーに登録
  - リストやMyカレンダーに一覧表示
- LINE通知機能
  - リマインド
  - レビュー依頼通知
- レビュー投稿機能
- みんなの猫スポット投稿・編集・削除機能
- レスポンシブ
- Twitterシェア
### 本リリース
- LINEシェア
- レビューに応じたレコメンド
- PWAによる擬似モバイルアプリ化
- スポット詳細に合わせて行けるおすすめの付近のスポット紹介
- Instagram graph APIから抽出した投稿から必要なイベント情報（イベント名、日付、場所）を正規表現などでパースする
- 取得したイベント情報をカレンダーに一覧表示させる
  - 日時や場所からプルダウンで絞り込みできるようにする
## 🐈 機能の実装方針予定（検証未）
|  | 使用技術 |
| ---- | ---- |
| フロントエンド | TailwindCSS（＋daisyUI）<br>JavaScript<br>Hotwire |
| バックエンド | Ruby 3.2.2<br>Ruby on Rails 7.1.2 |
| データベース | PostgreSQL |
| インフラ | Heroku<br>AmazonS3 |
| API | Google Maps JavaScript API<br>Google Places API<br>Google Geolocation API<br>Instagram graph API<br>LINE messenger API |
| Gem | gmaps4rails 2.0<br>geocoder 1.8.2<br>google_places<br>simple calendar 3.0.2 |
| その他 | Docker |
- Google Places APIでスポット詳細情報の取得・表示（あらかじめDBに保存しておく）
- Google Maps JavaScript APIで地図表示
- Google Geolocation APIで現在地周辺の猫スポットを取得
- Ransackを用いた検索機能（カテゴリー・地域から）
- スポット詳細表示
  - Google Places APIで取得したスポット詳細情報を表示させる
  - Instagram graph APIでタグから関連投稿を取得し表示させる
- Instagram graph APIから抽出した投稿から必要なイベント情報（イベント名、日付、場所）を正規表現などを用いてパースする
- simple calendarを用いて取得したイベント情報をカレンダーに一覧表示させる
- LINE APIでLINE通知機能とログイン機能実装

## 画面遷移図
https://www.figma.com/file/I5K5nm237QJwWo64gCTjdm/Nekospot?type=design&node-id=0%3A1&mode=design&t=8og5QESets43UqBY-1

## ER図
[![](https://mermaid.ink/img/pako:eNq9V11v2zYU_SuCnts_kOdiwNCXAn0bDBiMdCMTkUiBotIZaYBYRJvso7CH1MmCZdjarkXTBWuHrc3mNM1_GWM5_hcj9RWbtud8rIUAWeY9Ju8591yKXrUd6oK9YAO7hZHHUFAjcQQssu7fv3mTrlqwAoTXFyldDhBbjqwFq2araxwUhXQuhsEKhnszgiGN-IyQj5dhRsihQaCym7lggImrB8qwgzh4lGEYS_w8nn_7b05jGJNTJtZc6cZRk2nmYkylPxaaoK8vy8pFWNWPlrWIPUy4hV3rzu18JOIME0_NS6CuoXXsjgUICkDNJ8ULKd7L5J269zuP9PQjILSCOGIaljyVoiOTEwUzMCGDJXB4zPR0Q3E8bG31e3uDvW9LnEoMPGAWo76GpC_3h7udMshxABFHQWg5DFTd3DriZiQO3ZHIWk4_L9BM-jopBsRRohZ2aFqf3Z6qQPK3FD9KIaTYnFRAVwL5dd09Gb23px9OBt1X_fahKZXLIIoU5vS4nX61bpIPG1QVgsTBImg9hz8cne3_PnUiGgIh6qHeoHEG3f6m39tJd5Ph9lYJdcHBAfItH3HM4yy1weHrfu-FAZDr6z4lXoZRzzX77Oh4BFVy9JEDlT84fKmUDJAHkanOw93B3k_Gj5lKQX3UbI9SzwcpDqTYkuK5dlXrt3--f5B231zWMVc2xUjnz2uMqvq_SvFQJn9K8Wq0BYoJy86_iM90l1UeGxnXTq3GSz9wqm1ViTc4bPc7m2f73dMPT0zrLCk-xPWb2lu9XrrRka1nsrUlW10T6fiAiO74zIjpXw_S48fTYMrTGfU_sup-V8muK79I3WYRFE-kUPfNa5el2AnnlSQAF6N6zPxs_bdS_CzFo8Hjo75oGw7KkbwZ5luYynNDJs_0JqV2qOQXKXYm-k9xVhbXsnzdHbw8-fyWMeU5hRKS7jxXXWd6F5jqK0yWK1hmHKXkawPpoJBjSs6n2ztItzcMUANFDY68PDMp2rrRkkPdPprIm4ksC_xUsAHVdYiK_SM5UGQ-WRcar9SL9M5Yj8zqqev575IZZb_5eCnlb_iLbitXeG_Nre6cZtc5aw4TxKrAVF75OeZyvEYGtSxXXN8qXgHlael_yKHS6FqSnJ_8Pobv8tnrZQrFuvYNO9A7FXbVmT9btmbzBqi4rU-RLiyh2Oe61msKimJO7zaJYy9wFsMNO6dR_FGwF5aQH6nREJEvKC2_r_0Lv3e_nQ?type=png)](https://mermaid-js.github.io/mermaid-live-editor/edit#pako:eNq9V11v2zYU_SuCnts_kOdiwNCXAn0bDBiMdCMTkUiBotIZaYBYRJvso7CH1MmCZdjarkXTBWuHrc3mNM1_GWM5_hcj9RWbtud8rIUAWeY9Ju8591yKXrUd6oK9YAO7hZHHUFAjcQQssu7fv3mTrlqwAoTXFyldDhBbjqwFq2araxwUhXQuhsEKhnszgiGN-IyQj5dhRsihQaCym7lggImrB8qwgzh4lGEYS_w8nn_7b05jGJNTJtZc6cZRk2nmYkylPxaaoK8vy8pFWNWPlrWIPUy4hV3rzu18JOIME0_NS6CuoXXsjgUICkDNJ8ULKd7L5J269zuP9PQjILSCOGIaljyVoiOTEwUzMCGDJXB4zPR0Q3E8bG31e3uDvW9LnEoMPGAWo76GpC_3h7udMshxABFHQWg5DFTd3DriZiQO3ZHIWk4_L9BM-jopBsRRohZ2aFqf3Z6qQPK3FD9KIaTYnFRAVwL5dd09Gb23px9OBt1X_fahKZXLIIoU5vS4nX61bpIPG1QVgsTBImg9hz8cne3_PnUiGgIh6qHeoHEG3f6m39tJd5Ph9lYJdcHBAfItH3HM4yy1weHrfu-FAZDr6z4lXoZRzzX77Oh4BFVy9JEDlT84fKmUDJAHkanOw93B3k_Gj5lKQX3UbI9SzwcpDqTYkuK5dlXrt3--f5B231zWMVc2xUjnz2uMqvq_SvFQJn9K8Wq0BYoJy86_iM90l1UeGxnXTq3GSz9wqm1ViTc4bPc7m2f73dMPT0zrLCk-xPWb2lu9XrrRka1nsrUlW10T6fiAiO74zIjpXw_S48fTYMrTGfU_sup-V8muK79I3WYRFE-kUPfNa5el2AnnlSQAF6N6zPxs_bdS_CzFo8Hjo75oGw7KkbwZ5luYynNDJs_0JqV2qOQXKXYm-k9xVhbXsnzdHbw8-fyWMeU5hRKS7jxXXWd6F5jqK0yWK1hmHKXkawPpoJBjSs6n2ztItzcMUANFDY68PDMp2rrRkkPdPprIm4ksC_xUsAHVdYiK_SM5UGQ-WRcar9SL9M5Yj8zqqev575IZZb_5eCnlb_iLbitXeG_Nre6cZtc5aw4TxKrAVF75OeZyvEYGtSxXXN8qXgHlael_yKHS6FqSnJ_8Pobv8tnrZQrFuvYNO9A7FXbVmT9btmbzBqi4rU-RLiyh2Oe61msKimJO7zaJYy9wFsMNO6dR_FGwF5aQH6nREJEvKC2_r_0Lv3e_nQ)
