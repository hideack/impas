# -*- encoding: utf-8 -*-
require 'faraday'

desc '全クロール'
task :all_crawle do
  logger.info "Parameter crawle start."

  Url.order('updated_at desc').limit(3000).each do |url|
    url.tw = tweetNum(url.url)
    url.fb = likeNum(url.url)
    url.hatena = hatebuNum(url.url)
    url.save
    sleep 1
  end

  logger.info "Parameter crawle finish."
end

desc 'ツイート数取得'
task :tweet do
end

desc 'いいね数取得'
task :fblike do
end

desc 'はてぶ数取得'
task :hatenabookmark do
end

def tweetNum(url)
  conn = Faraday.new(:url => 'http://urls.api.twitter.com/') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end

  res = conn.get "/1/urls/count.json", {:url => url}

  if res.status == 200
    begin
      params = JSON.parse(res.body)
      params["count"]
    rescue
      0
    end
  else
    logger.error "Twitter API calling failed."
    0
  end
end

def likeNum(url)
  conn = Faraday.new(:url => 'http://graph.facebook.com/') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end
 
  res = conn.get "/#{CGI.escape(url)}"

  if res.status == 200
    begin
      params = JSON.parse(res.body)
      params["shares"].to_i
    rescue
      0
    end
  else
    logger.error "facebook API calling failed."
    0
  end
end

def hatebuNum(url)
  conn = Faraday.new(:url => 'http://api.b.st-hatena.com/') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end
 
  res = conn.get "/entry.count", {url: url}

  if res.status == 200
    begin
      res.body.to_i
    rescue
      0
    end
  else
    logger.error "Hatena bookmark API calling failed."
    0
  end
end

