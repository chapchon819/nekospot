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
- PWAによる擬似モバイルアプリ化
- スポット詳細に合わせて行けるおすすめの付近のスポット紹介
- チェックイン機能
- レビュー投稿やチェックイン数に応じたメダル贈呈機能
- 閲覧履歴
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
- Ransackを用いた検索機能（スポット名・住所でフリーワード検索）
- スポット詳細表示
  - Google Places APIで取得したスポット詳細情報を表示させる
  - スポットのXを埋め込んで最新情報を表示させる
- チェックイン機能
 - チェックインしたスポットがカレンダーに記録される
- レビュー投稿やチェックイン数に応じたメダル贈呈機能

## 画面遷移図
https://www.figma.com/file/I5K5nm237QJwWo64gCTjdm/Nekospot?type=design&node-id=0%3A1&mode=design&t=8og5QESets43UqBY-1

## ER図
[![](https://mermaid.ink/img/pako:eNq1V11P2zAU_StRnuEP8IwmTXuZtLcJqXITk1okduU4bAiQ1lh8bBNqJygMjWljEwgYGkwb6wYD_stMU_gXs_PRNmkLhTJVSpvck-tzj8-9Sad1g5hQH9EhHUXAosAZw54LqavNzAwPk2kNTkLMcnlCJhxAJ1xtRBvT5ScNcovkRgyFkwg-6xEsEpf1CNloAvYIGcRxJLueCzoIm-pCEjYAgxahCKaIt-LR2fU1pTDZmkKxbpQujeqkGYnRtfxUqKP8IoXj0GAebRUYKXINIK1AF0DM9hpEevOijxavPK1-aloeWQgzDZna40fRFZWGQmzINK2U2oM46jKKsCWLxzCnEuWQmQpg4EC5nuDbgv8R_k95rFeW1PJtIDAJGKAK5n8SvCL8cwlLMJIOtCDVKLFVpmBn92q9kgQZcqDLgFPUDAqlacwcYNmIVzTbIrNR0ZGa_RQde3GqWXJfgiR1-78Ffy84F3yxs261H8DOqcaW2Ct-dHF23qju1cu1rECm3EVXYi5Oy8HLF9k0BSLVx56Th0rEq3cnl7vfuuYhRYix_JErEC-Err6uH68F6_7V6nICNaGBHGBrNmCIeSGzRu2gfrzdASDYShCXJ6dtiISXDQzYNASDz6XEDrCgmxVmfr2x8SFzM5XLy68x3SLEsqHg-4IvC76lbFT6-vftXFA9HNgFbXOmpxWyG_pF8Hnh_xB8r93LccL2pusnY9utyYjqx5Oq07r5Ubm6eT1pHEaUyZp6NmrlemXxcrd6cbaZ7bFxKQU27SnltOPjYKEiSp9FaVmUqlmkYUOAVdeHtgx-zQWnK91g0uGhat_DDX_T3DFlhjwxp-Ig3xRcHhcH3tF4CA42zRxoIpDzqB2yOxL8o-BLjZWTOi9nC1QtLC2uNHhVbeycPxzN-LjFN4EEa1uy47K9AqnsKYQnmrDQYFK2gwzSAEWGCG6l29gPVhcyoAJwCwxYETPBy6rR_JpqHzlb_cMOljG-KzgDVaK78ezw92Ux9zKL256-_exdyui9GmMwE92SUXjP_6MUPbrvaOsMm1s8qG7qU8VUMe8opxnoWk30rtTvpOssUYpxx_W1ePAnb2T3wKGp0UCStN4u_4fbouy5hEK8rj6kO2ruIFP-rwiXHdNZAcq4rl4STTgOPJupvZ6VUOAx8mQKG_oIox4c0qMy4j8j-sg4sF15tQjwU0KS89l_RMrKVw?type=png)](https://mermaid-js.github.io/mermaid-live-editor/edit#pako:eNq1V11P2zAU_StRnuEP8IwmTXuZtLcJqXITk1okduU4bAiQ1lh8bBNqJygMjWljEwgYGkwb6wYD_stMU_gXs_PRNmkLhTJVSpvck-tzj8-9Sad1g5hQH9EhHUXAosAZw54LqavNzAwPk2kNTkLMcnlCJhxAJ1xtRBvT5ScNcovkRgyFkwg-6xEsEpf1CNloAvYIGcRxJLueCzoIm-pCEjYAgxahCKaIt-LR2fU1pTDZmkKxbpQujeqkGYnRtfxUqKP8IoXj0GAebRUYKXINIK1AF0DM9hpEevOijxavPK1-aloeWQgzDZna40fRFZWGQmzINK2U2oM46jKKsCWLxzCnEuWQmQpg4EC5nuDbgv8R_k95rFeW1PJtIDAJGKAK5n8SvCL8cwlLMJIOtCDVKLFVpmBn92q9kgQZcqDLgFPUDAqlacwcYNmIVzTbIrNR0ZGa_RQde3GqWXJfgiR1-78Ffy84F3yxs261H8DOqcaW2Ct-dHF23qju1cu1rECm3EVXYi5Oy8HLF9k0BSLVx56Th0rEq3cnl7vfuuYhRYix_JErEC-Err6uH68F6_7V6nICNaGBHGBrNmCIeSGzRu2gfrzdASDYShCXJ6dtiISXDQzYNASDz6XEDrCgmxVmfr2x8SFzM5XLy68x3SLEsqHg-4IvC76lbFT6-vftXFA9HNgFbXOmpxWyG_pF8Hnh_xB8r93LccL2pusnY9utyYjqx5Oq07r5Ubm6eT1pHEaUyZp6NmrlemXxcrd6cbaZ7bFxKQU27SnltOPjYKEiSp9FaVmUqlmkYUOAVdeHtgx-zQWnK91g0uGhat_DDX_T3DFlhjwxp-Ig3xRcHhcH3tF4CA42zRxoIpDzqB2yOxL8o-BLjZWTOi9nC1QtLC2uNHhVbeycPxzN-LjFN4EEa1uy47K9AqnsKYQnmrDQYFK2gwzSAEWGCG6l29gPVhcyoAJwCwxYETPBy6rR_JpqHzlb_cMOljG-KzgDVaK78ezw92Ux9zKL256-_exdyui9GmMwE92SUXjP_6MUPbrvaOsMm1s8qG7qU8VUMe8opxnoWk30rtTvpOssUYpxx_W1ePAnb2T3wKGp0UCStN4u_4fbouy5hEK8rj6kO2ruIFP-rwiXHdNZAcq4rl4STTgOPJupvZ6VUOAx8mQKG_oIox4c0qMy4j8j-sg4sF15tQjwU0KS89l_RMrKVw)
