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
- イベントや猫スポットはネット検索でも取得できるが、情報が点在しているため、それを一元化させることで検索をスムーズにする
## 🐈 機能候補
### MVPリリース
- LINEログイン
- Google Places APIでスポット詳細情報の取得・表示（あらかじめDBに保存しておく）
- Google Maps JavaScript APIで地図表示
- Google Geolocation APIで現在地周辺の猫スポットを取得
- 検索機能（カテゴリー・地域から）
- スポット詳細表示
  - Instagram graph APIで関連投稿を取得し表示させる
- Instagram graph APIから抽出した投稿から必要なイベント情報（イベント名、日付、場所）を正規表現などでパースする
- 取得したイベント情報をカレンダーに一覧表示させる
  - 日時や場所からプルダウンで絞り込みできるようにする
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
- スポット詳細に合わせて行けるおすすめの付近のスポット紹介
### 本リリース
- LINEシェア
- レビューに応じたレコメンド
- PWAによる擬似モバイルアプリ化
## 🐈 機能の実装方針予定（検証未）
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
