twikeshi
========

自動ツイ消しスクリプト

使い方
-----

1. `twikeshi-conf.yaml`を書く
2. cronに登録
3. おわり

`twikeshi-conf.yaml`の記述例
----------------------------

```
# ログファイル
logfile: /var/log/twikeshi.log
# アカウント（複数アカウントに対応）
accounts:
  - consumer_key: aaaaaaaaa
    consumer_secret: bbbbbbbbb
    access_token: ccccccccccc
    access_token_secret: ddddddddddddd
	# 一ヶ月経過したツイートを削除
    mon: 1
  - consumer_key: eeeeeeeee
    consumer_secret: fffffffff
    access_token: ggggggggggggg
    access_token_secret: hhhhhhhhhhhhh
	# ３日経過したツイートを削除
    day: 3
```
