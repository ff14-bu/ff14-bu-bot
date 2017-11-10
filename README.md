# ff14-bu-bot

ff14-bu-bot は [FINAL FANTASY XIV (FF14)](https://jp.finalfantasyxiv.com) のゲーム内情報の検索などを行う [Discord](https://discordapp.com/) 用のボットです。

## コマンドリスト

| command                | description                                      | example                        |
|------------------------|--------------------------------------------------|--------------------------------|
| `/gather <アイテム名>` | アイテム名のギャザラー情報を探します。           | `/gather シュラウドソイルG3`   |
| `/hunt <アイテム名>`   | モンスターから得られるアイテムの情報を探します。 | `/hunt ボムの灰`               |
| `/market <アイテム名>` | アイテムの入手情報を探します。                   | `/market クレリックキュロット` |
| `/shop <アイテム名>`   | アイテムのショップ情報を探します。               | `/shop 食塩`                   |

## 動かし方

ff14-bu-bot は [Ruby](https://www.ruby-lang.org/ja/) を使っています。ff14-bu-bot を動かすのには Ruby と [Bundler](https://bundler.io/) が必要です。あらかじめインストールしてください。

また ff14-bu-bot は [Foreman](https://github.com/ddollar/foreman) を用いたプロセス管理に対応しています。Foreman がインストールされている環境でのとコマンドの実行が簡単になります。Foreman のインストールも推奨します。

```console
$ gem install bundler
$ gem install foreman
$ git clone https://github.com/ff14-bu/ff14-bu-bot.git
$ cd ff14-bu-bot
$ bundle install --path .bundle
$ foreman start
```

## デプロイ

ff14-bu-bot はチャットボットであるという都合上、24時間稼動し続ける必要があります。そのため [Heroku](https://www.heroku.com/) などの PaaS を利用して動かすことを推奨します。

Heroku のアカウントを持っていれば下のボタンから簡単に ff14-bu-bot を Heroku にデプロイすることができます。

[![Heroku にデプロイ](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## ライセンス

```
記載されている会社名・製品名・システム名などは、各社の商標、または登録商標です。
Copyright (C) 2010 - 2017 SQUARE ENIX CO., LTD. All Rights Reserved.
```

## 謝辞

- [FF14 ERIONES - エリオネス](https://eriones.com/)
