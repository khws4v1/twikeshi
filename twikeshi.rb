#!/usr/bin/env ruby                                   
# coding: utf-8

require "optparse"
require "twitter"

sec                 = 0
min                 = 0
hour                = 0
day                 = 0
consumer_key        = ""
consumer_secret     = ""                                                                                                                                                                                                                     
access_token        = ""                                                                                                                                                                                                                     
access_token_secret = ""                                                                                                                                                                                                                     

opt = OptionParser.new                                                                                                                                                                                                                       
opt.on("-s value", "--second value", "秒数を指定します。") {|v|
    sec = v.to_i if v.to_i >= 0
}
opt.on("-m value", "--minute value", "分数を指定します。") {|v|
  min = v.to_i if v.to_i >= 0
}
opt.on("-h value", "--hour value", "時間数を指定します。") {|v|
  hour = v.to_i if v.to_i >= 0
}
opt.on("-d value", "--day value", "日数を指定します。") {|v|
  day = v.to_i if v.to_i >= 0
}
opt.on("--consumer-key key", "TwitterAPIのコンシュマーキーを指定します。") {|v|
  consumer_key = v
}
opt.on("--consumer-secret key", "TwitterAPIのコンシュマーキーシークレットを指定します。"  ) {|v|
  consumer_secret = v
}
opt.on("--access-token token", "TwitterAPIのアクセストークンを指定します。") {|v|
  access_token = v
}
opt.on("--access-token-secret token", "TwitterAPIのアクセストークンシークレットを指定します。") {|v|
  access_token_secret = v
}

opt.parse!(ARGV)

if consumer_key.empty? || consumer_secret.empty? || access_token.empty? || access_token_secret.empty? then
  STDERR.puts "引数が正しくありません。"
  exit -1
end

rest_client = Twitter::REST::Client.new {|config|
  config.consumer_key        = consumer_key
  config.consumer_secret     = consumer_secret
  config.access_token        = access_token
  config.access_token_secret = access_token_secret
}
target_time = Time.now - sec - min*60 - hour*3600 - day*86400
max_id = 0
twikeshi_count = 0

begin
  target_user = rest_client.verify_credentials
  loop {
    statuses = {}
    if max_id == 0 then
      statuses = rest_client.user_timeline(target_user, :count => 200)
    else
      statuses = rest_client.user_timeline(target_user, :max_id => max_id, :count => 200)
    end
    statuses.each{|status|
      if status.created_at < target_time then
        rest_client.destroy_status(status)
        puts "ツイートを削除しました。 ID: #{status.id} Text: #{status.text}"
        twikeshi_count = twikeshi_count + 1
      end
      max_id = status.id - 1 if max_id == 0 || max_id > status.id
    }
    break if statuses.empty?
  }
rescue Twitter::Error::TooManyRequests => error
  STDERR.puts "API制限に達したので#{error.rate_limit.reset_in + 1}秒待機します。"
  sleep error.rate_limit.reset_in + 1
  retry
rescue Twitter::Error::ClientError => error
  STDERR.puts "エラーが発生しました。: #{error.to_s}"
  sleep 10
end

puts "ツイ消しが完了しました。"
puts "消したツイートの数: #{twikeshi_count.to_s}"
