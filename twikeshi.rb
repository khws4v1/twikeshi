#!/usr/bin/env ruby
# coding: utf-8

require 'twitter'
require 'yaml'
require 'date'
require 'logger'

class Account

  def initialize(hash)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = hash['consumer_key']
      config.consumer_secret     = hash['consumer_secret']
      config.access_token        = hash['access_token']
      config.access_token_secret = hash['access_token_secret']
    end
    @year = hash['year'] if hash.key?('year')
    @mon  = hash['mon']  if hash.key?('mon')
    @day  = hash['day']  if hash.key?('day')
    @hour = hash['hour'] if hash.key?('hour')
    @min  = hash['min']  if hash.key?('min')
    @sec  = hash['sec']  if hash.key?('sec')
  end

  def client
    @client
  end

  # いつ以降ツイートを残すかを返す
  def remain
    dt = DateTime.now
    dt = dt << @year * 12                  if @year != nil
    dt = dt << @mon                        if @mon  != nil
    dt = dt - @day                         if @day  != nil
    dt = dt - Rational(@hour, 24)          if @hour != nil
    dt = dt - Rational(@min, 24 * 60)      if @min  != nil
    dt = dt - Rational(@sec, 24 * 60 * 60) if @sec  != nil
    dt.to_time
  end
end

# 設定ファイル名
CONFIG = 'twikeshi-conf.yaml'
# 設定ファイルのオブジェクト
yaml   = YAML.load_file(CONFIG)
# アカウント
accounts = Array.new
# ログ
log = Logger.new(yaml['logfile'] == nil ? STDERR : yaml['logfile'])

yaml['accounts'].each do |account|
  accounts << Account.new(account)
end

begin
  accounts.each do |account|
    # 認証したTwitterアカウントのユーザオブジェクトを取得
    user = account.client.verify_credentials
    max_id = 0
    
    loop do
      tweets = Array.new
      if max_id == 0 then
        tweets = account.client.user_timeline(user, :count => 200)
      else
        tweets = account.client.user_timeline(user, :count => 200, :max_id => max_id)
      end
      tweets.each do |tweet|
        if tweet.created_at < account.remain then
          account.client.destroy_status(tweet)
          log.info("#{user.id} @#{user.screen_name}: Status #{tweet.id} is destroyed.")
        end
        max_id = tweet.id - 1 if max_id == 0 || max_id > tweet.id
      end
      break if tweets.empty?
    end
  end
rescue Twitter::Error::TooManyRequests => error
  log.warn(error.to_s)  
  sleep error.rate_limit.reset_in + 1
  retry
end
