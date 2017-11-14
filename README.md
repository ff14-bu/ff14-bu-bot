# ff14-bu-bot

ff14-bu-bot は [FINAL FANTASY XIV (FF14)](https://jp.finalfantasyxiv.com) のゲーム内情報の検索などを行う [Discord](https://discordapp.com/) 用のチャットボットです。

## コマンドリスト

| command                | description                                      | example                        |
|------------------------|--------------------------------------------------|--------------------------------|
| `/gather <アイテム名>` | アイテム名のギャザラー情報を探します。           | `/gather シュラウドソイルG3`   |
| `/hunt <アイテム名>`   | モンスターから得られるアイテムの情報を探します。 | `/hunt ボムの灰`               |
| `/market <アイテム名>` | アイテムの入手情報を探します。                   | `/market クレリックキュロット` |
| `/shop <アイテム名>`   | アイテムのショップ情報を探します。               | `/shop 食塩`                   |
| `/fish <魚の名前>`     | 魚の情報を探します。                             | `/fish ザリガニ`               |

## 動かし方

### ソースコードの取得

ff14-bu-bot のソースコードは [GitHub](https://github.com/) で管理されています。ソースコードの取得には [Git](https://git-scm.com/) が必要となります。Git を使ってソースコードの取得を行ってください。

```console
$ git clone https://github.com/ff14-bu/ff14-bu-bot.git
$ cd ff14-bu-bot
```

### 依存するソフトウェアのインストール

ff14-bu-bot は [Ruby](https://www.ruby-lang.org/ja/) を使っています。プラットフォームによってインストールする方法はさまざまであるため、Ruby のインストール方法については省略します。

また依存ライブラリーの管理には [Bundler](https://bundler.io/) を用いています。Bundler は Ruby 2.4.2 時点では同梱されていません。別途インストールしてください。Bundler のインストールは Ruby をインストールした際に併せてインストールされる `gem` コマンドから行えます。

```console
$ gem install bundler
```

また ff14-bu-bot は [Foreman](https://github.com/ddollar/foreman) を用いたプロセス管理に対応しています。Foreman がインストールされている環境ではコマンドの実行が簡単になります。必須ではありませんが Foreman のインストールも推奨します。

```console
$ gem install foreman
```

### 依存するライブラリーのインストール

依存するライブラリーは [`Gemfile`](/Gemfile) に記載してあります。前節「[依存するソフトウェアのインストール](#依存するソフトウェアのインストール)」でインストールした Bundler を用いることでこれらのライブラリーのインストールを簡単に行えます。

```console
$ bundle install --path vendor/bundle
```

### Foreman を使って起動

ff14-bu-bot は Discord のチャットボットです。そのため Discord のボットユーザーのトークンが必要となります。[Discord - My Apps (要ログイン)](https://discordapp.com/developers/applications/me) からアプリケーションの作成を行ってボットユーザーのトークンを取得してください。

ボットユーザーのトークンは環境変数「`DISCORD_TOKEN`」を用いて設定します。Foreman は `.env` という名前のファイルに環境変数の名前と値が「`=`」を区切って記述されている場合、起動したプロセスの環境変数としてそれらの値が使われるようになります。なので `DISCORD_TOKEN=` の後に前段落で取得したボットユーザーのトークンをつなげて `.env` ファイルに記述しておくと良いでしょう。

Foreman を使うのであればプロセスの起動は `foreman start` だけで済みます。とくに気をつけることはないでしょう。

```console
$ echo DISCORD_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxx > .env
$ foreman start
```

## デプロイ

ff14-bu-bot はチャットボットであるという都合上、24時間稼動し続ける必要があります。そのため [Heroku](https://www.heroku.com/) などの PaaS を利用して動かすことを推奨します。

Heroku のアカウントを持っていれば下のボタンから簡単に ff14-bu-bot を Heroku にデプロイすることができます。

[![Heroku にデプロイ](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

動作の保証はできませんが Heroku 以外の環境でも運用することができます。その場合は前章「[動かし方](#動かし方)」をご参照ください。

負荷がかかるような大きな処理はしていないため、CPU が仮想1コアの性能の低い VPS 環境下でも問題なく動かせられるかと思います。ただし外部のウェブサイトから情報を取得する仕様になっているため、外向きのインターネット接続ができる必要があります。

## ライセンス

```
記載されている会社名・製品名・システム名などは、各社の商標、または登録商標です。
Copyright (C) 2010 - 2017 SQUARE ENIX CO., LTD. All Rights Reserved.
```

## 謝辞

ff14-bu-bot は下記のウェブサイトから情報の検索を行っています。

- [FF14 ERIONES - エリオネス](https://eriones.com/)
- [猫はお腹がすいた](http://ff14angler.com/)
