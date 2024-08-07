## 🐈 アプリ名：NekoSpot
![ベージュ　シンプル　クラフト紙　ファイナンス　告知　Twitter投稿 (1).png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3551101/cc6dd1a9-fc15-b40f-06a4-eaeb2bdb8e7b.png)
<img src="https://img.shields.io/badge/-RubyonRails-CC0000.svg?logo=rubyonrails&style=popout"> <img src="https://img.shields.io/badge/-Ruby-CC342D.svg?logo=ruby&style=popout"> <img src="https://img.shields.io/badge/-Javascript-F7DF1E.svg?logo=javascript&style=popout">
 <img src="https://img.shields.io/badge/-GithubActions-CC0000.svg?logo=githubactions&style=popout"> <img src="https://img.shields.io/badge/-Docker-1488C6.svg?logo=docker&style=popout"> <img src="https://img.shields.io/badge/-Postgresql-336791.svg?logo=postgresql&style=popout"> <img src="https://img.shields.io/badge/-Amazon-FF9900.svg?logo=amazon&style=popout">
## 🐈 サービスURL
https://nekospot.jp
## 🐈 サービス概要
猫スポット特化型検索サービスです。現在地や地域、カテゴリー、タグ、里親募集の有無などから検索可能です。加えてレビューでスポットの情報をシェアすることができます。気軽に触ってもらえるように「猫スポット診断機能」を実装しています。またディープなユーザーにも楽しんでもらえるようにレビュー数と訪問済み数から会員ランクも設定しています。
## 🐈 このサービスへの思い・作りたい理由
私にとって猫はとても尊い存在です。しかし、ペット不可の賃貸に住んでいるため猫を飼うことができません。猫と触れ合う機会を作るため、猫と触れ合えるスポットやイベントの情報収集をする際に、猫カフェはGoogleMapから検索しやすいですが、その他のスポットは一元化されたアプリやサイトがないことに気付きました。それなら自分で作ってしまおうと思ったのが発案のきっかけです。全国の猫好きの皆さんのQOLを少しでも向上させたいです。
## 🐈 ユーザー層について
- 猫が好きな人
- 動物が好きな人
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
- レスポンシブ
- 会員ランクの設定
- スポット詳細にX埋め込み(PC画面のみ。スマホ画面はリンクボタンで対応)
- Xシェア
- LINEシェア
- PWAによる擬似モバイルアプリ化
- Cloud Vision APIによる猫画像優先表示
- サイトマップ
- 動的OGP(レビュー画像・スポット画像)
## 🐈 使用技術
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
