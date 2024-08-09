![ベージュ　シンプル　クラフト紙　ファイナンス　告知　Twitter投稿 (1).png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3551101/cc6dd1a9-fc15-b40f-06a4-eaeb2bdb8e7b.png)
<img src="https://img.shields.io/badge/-RubyonRails-CC0000.svg?logo=rubyonrails&style=popout"> <img src="https://img.shields.io/badge/-Ruby-CC342D.svg?logo=ruby&style=popout"> <img src="https://img.shields.io/badge/-Javascript-F7DF1E.svg?logo=javascript&style=popout">
 <img src="https://img.shields.io/badge/-GithubActions-CC0000.svg?logo=githubactions&style=popout"> <img src="https://img.shields.io/badge/-Docker-1488C6.svg?logo=docker&style=popout"> <img src="https://img.shields.io/badge/-Postgresql-336791.svg?logo=postgresql&style=popout"> <img src="https://img.shields.io/badge/-Amazon-FF9900.svg?logo=amazon&style=popout">
## 🐈 サービス名
### [NekoSpot](https://nekospot.jp)
メイン機能である猫スポット検索機能と猫スポット診断機能は、ログインせずお試しいただけます。
## 🐈 サービス概要
猫スポット特化型検索サービスです。

具体的には、
- マップと一覧から検索することができ、現在地や地域、カテゴリー、タグ、里親募集の有無などから検索することができます。
- スポットのレビューで情報をシェアすることができます。
- 「猫スポット診断機能」でおすすめの猫スポットを提案します。
- お気に入り機能で気になったスポットをお気に入りに登録でき、訪問したスポットは訪問済にすることができます。
- ディープなユーザーにも楽しんでもらえるようにレビュー数と訪問済み数から会員ランクを設定しております。
## 🐈 このサービスへの思い・作りたい理由
私にとって猫はとても尊い存在です。しかし、ペット不可の賃貸に住んでいるため猫を飼うことができません。猫と触れ合えるスポットやイベントの情報収集をする際に、猫カフェはGoogleMapから検索しやすいですが、その他のスポットは一元化されたアプリやサイトがないことに気付きました。それなら自分で作ってしまおうと思ったのが発案のきっかけです。全国の猫好きの皆さんのQOLを少しでも向上させたいと考えております。
## 🐈 ユーザー層について
- 猫が好きな方
- 動物が好きな方
## 🐈 サービスの利用イメージ
- 現在地・地域、カテゴリー等から猫スポットを検索することができる
- レビューで情報をシェア・確認できる
- レビュー投稿や訪問済により会員ランクを上げることができる
- 猫スポット診断機能で気軽におすすめスポットを発見・シェアできる
- 気になったスポットはお気に入りに登録できる
- スポットの詳細情報を確認できる
## 🐈 ユーザーの獲得について
- Xシェア
- Qiitaで技術記事執筆
## 🐈 サービスの差別化ポイント・推しポイント
類似サービスとして以下のサービスが挙げられますが、Mapから猫と出会える・触れ合えるスポット【だけ】を検索できるサービスは存在しない。
- [猫スポットなび](https://nekospot.com/)
- [猫スポット日本全国マップ](https://nekospot.info/)


また上記以外のサービスとの差別化としては、以下の通りです。
- 猫カフェはGoogleMapから検索可能ですが、細かなレビューやスポットのXを表示させることでスポットでの体験をより想像しやすくする
- 猫カフェ以外の猫と触れ合えるスポットはGoogle検索からでは、猫と触れ合えるスポット以外も表示されるため求めている情報の取得が難しい。
- 「猫カフェ」などのキーワードからのスポット検索ではある程度ヒットするが、「兵庫県」など場所から猫スポットを絞り込むことはできない。
- イベントや猫スポットはネット検索でも取得できるが、情報が点在しているため、それを一元化させることで検索をスムーズにする。
## 🐈 機能一覧
### メイン機能
| 猫画像スライド＆機能紹介 | Map検索機能① | Map検索機能② |
| ---- | ---- | ---- |
|　 [![Image from Gyazo](https://i.gyazo.com/feaef78e369dab37225fde6dcba9c23c.gif)](https://gyazo.com/feaef78e369dab37225fde6dcba9c23c) | [![Image from Gyazo](https://i.gyazo.com/78301cf93079ab6554b1dd95da241b63.gif)](https://gyazo.com/78301cf93079ab6554b1dd95da241b63) | [![Image from Gyazo](https://i.gyazo.com/43bc0b8ced42a483c8e74087c5531589.gif)](https://gyazo.com/43bc0b8ced42a483c8e74087c5531589) |
| 猫画像を優先表示させることでスライダーを作成しています。機能紹介で何ができるアプリなのか一目でわかるようにしています。　　　　　　　　　| 現在地を取得し周辺の猫スポットを表示します。リストを押すと現在地周辺10km県内の猫スポットが近い順に最大10件表示されます。中央のピンの動きに合わせて動的に周辺のスポットを取得します。ピンをクリックすると画面下部に情報カードが表示され、カードをクリックするとスポットの詳細情報を見ることができます。 | 「絞り込み」ボタンを押すと、フリーワード(スポット名・住所)、里親募集の有無、譲渡会開催実績の有無、カテゴリ、タグから猫スポットを検索できます。都道府県を選択すると選択した都道府県にジャンプします。 | 一覧からもスポット検索をすることができ、Googleの高評価順に並び替えることもできます。タブを切り替えると全スポットのレビュー一覧を見ることができます。　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　|

| 一覧検索 | 猫スポット診断機能 | レビュー投稿機能 |
| ---- | ---- | ---- |
| [![Image from Gyazo](https://i.gyazo.com/450baf919cc7ed4e24ae87fea60b353b.gif)](https://gyazo.com/450baf919cc7ed4e24ae87fea60b353b) | [![Image from Gyazo](https://i.gyazo.com/cbb1c10dd5ffb893c69b39cabf925590.gif)](https://gyazo.com/cbb1c10dd5ffb893c69b39cabf925590) | [![Image from Gyazo](https://i.gyazo.com/ea86e5f842549b09edd4964e2f962a41.gif)](https://gyazo.com/ea86e5f842549b09edd4964e2f962a41) |
| 一覧からもスポット検索をすることができ、Googleの高評価順に並び替えることもできます。タブを切り替えると全スポットのレビュー一覧を見ることができます。　　| ３つの質問に答えるだけで、おすすめの猫スポットを提案します。　　　　　　　　　　　　 | 各猫スポットにレビューを投稿することができます。　　　　　　　　　　　　　|

### 工夫したポイント

| [![Image from Gyazo](https://i.gyazo.com/f630fcfd89e70033f92107c5818f2893.png)](https://gyazo.com/f630fcfd89e70033f92107c5818f2893) | [![Image from Gyazo](https://i.gyazo.com/513d6400c23a6949ceadecc55af29109.png)](https://gyazo.com/513d6400c23a6949ceadecc55af29109) |
| ---- | ---- |
| 10個以上のアプリを使い比べた結果、上記のようなUI/UXにしました。　　| 猫スポットを運営されている方にとってもメリットがあるアプリにしたかったので、Xのタイムラインを表示させることでスポットの最新情報やおすすめ情報を掲載しました。|

| [![Image from Gyazo](https://i.gyazo.com/7f4e982f534bc7d3a922e2472f343438.jpg)](https://gyazo.com/7f4e982f534bc7d3a922e2472f343438) | [![Image from Gyazo](https://i.gyazo.com/1bc541cf756fd30fff234e78037a33fe.gif)](https://gyazo.com/1bc541cf756fd30fff234e78037a33fe) |
| ---- | ---- |
| 猫画像を優先的に表示させることで猫があふれる世界観を実現しました。　　| ユーザーが操作に迷わないようにボタンやマーク、会員ランクについてモーダルで説明しています。　　　　　　　　　　　　　　　　　　　|

### 機能一覧
- ソーシャルログイン(Google・LINE)
- スポット検索機能
  - フリーワード(スポット名・住所)
  - 里親募集の有無
  - 譲渡会開催実績の有無
  - カテゴリ
  - タグ
  - エリア検索(一覧)
  - 現在地(Map)
  - 選択エリアへ移動(Map)
  - 周辺10kmのスポットを10件リスト表示(Map)
- レビュー投稿・編集・削除機能(複数枚画像投稿・タグ)
- 猫スポット診断機能
- ユーザー編集
- Google Places APIにてスポット詳細情報の取得・表示
- オートコンプリート(フリーワード検索・タグ投稿)
- お気に入り登録機能
- 訪問済機能
- レビュー投稿の「参考になった」ボタン
- 会員ランクの設定
- スポット詳細にX埋め込み(PC画面のみ。スマホ画面はリンクボタンで対応)
- シェア(X・LINE)
- PWAによる擬似モバイルアプリ化
- Cloud Vision APIによる猫画像優先表示
- サイトマップ
- 動的OGP(レビュー画像・スポット画像)
## 🐈 使用技術
| カテゴリー | 使用技術 |
| ---- | ---- |
| フロントエンド | TailwindCSS<br>daisyUI<br>JavaScript<br>Hotwire |
| バックエンド | Ruby 3.2.2<br>Ruby on Rails 7.1.3 |
| データベース | PostgreSQL |
| インフラ | Heroku<br>AmazonS3<br>Redis |
| API | Google Maps JavaScript API<br>Google Places API<br>Google Geolocation API<br>Google Cloud Vision API |
| CI/CD | GithubActions |
| 開発環境 | Docker |
## 画面遷移図(未修正)
https://www.figma.com/file/I5K5nm237QJwWo64gCTjdm/Nekospot?type=design&node-id=0%3A1&mode=design&t=8og5QESets43UqBY-1

## ER図
![image](https://github.com/chapchon819/nekospot/assets/145883659/5220b9b9-e4d7-48db-b9f4-f65cb805d911)
