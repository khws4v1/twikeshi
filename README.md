twikeshi
========

自動ツイ消しスクリプト

使い方
-----

以下のようにConsumerKeyとかを入れてください。

`$ ruby twikeshi.rb --consumer-key YOUR_CONSUMER_KEY --consumer-secret YOUR_CONSUMER_SECRET --access-token YOUR_ACCESS_TOKEN -access-token-secret YOUR_ACCESS_TOKEN_SECRET`

これであなたのツイートが**すべて**消えます。

ある程度は残しておきたいときはどのくらい前のツイートを残すかを指定します。

`$ ruby twikeshi.rb -s 30 -m 5 -h 10 -d 3 --consumer-key YOUR_CONSUMER_KEY --consumer-secret YOUR_CONSUMER_SECRET --access-token YOUR_ACCESS_TOKEN -access-token-secret YOUR_ACCESS_TOKEN_SECRET`

これで3日と10時間と5分と30秒より前のツイートだけを消します。  
ただし、Twitter APIは最近の3200ツイートしか表示できない~~クソ~~仕様なので期間が長すぎると消せないかもしれません。

cronで定期的に実行すれば古いツイートを定期的に消せます。  
すごいですね。

注意事項
-------
* **バグでツイートが全部消えても責任は取りません。**実行したお前が悪い。
* ツイートを消してもどっかに埋め込まれてると埋め込まれていた場所にテキストだけガッツリ残ります。（Twitterのクソ仕様）
* togetterで晒された場合はそちらは消えてくれないので別途自分で消す必要があります。（togetterのクソ仕様）
* 誰かが撮ったスクリーンショットを消す超能力はありません。
* ウェブアーカイブに保存されたアーカイブを消す機能はありません。
* 非公式RTで誰かにツイートの本文を晒されてもその非公式RTは消えません。
* 誰かにツイートを盗用されててもそのツイートは消えません。

