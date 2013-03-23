# Helper methods defined here can be accessed in any controller or view in the application
require 'json'
require 'URI'
require './recommender/recommender.rb'

Impas.helpers do
  def generateResponse(flg, expl, detail)
    content_type :json

    resFlag = flg ? "ok" : "ng"
    apiRes = {result:resFlag, explain:expl, description: detail}
    apiRes.to_json
  end

  def validateJsonCommand(rule, json)
    ruleFile = "#{PADRINO_ROOT}/rule/#{rule}.json"
    JSON::Validator.validate(ruleFile, json)
  end

  def parseCommand(json)
    begin
      JSON.parse(json)
    rescue
      nil
    end
  end

  def checkOpKey(key)
    unless !User.find_by_opkey(key).nil?
      return 401
    else
      yield
    end
  end

  def checkKey(key)
    unless !Group.find_by_key(key).nil?
      return 401
    else
      yield
    end
  end

  def groupMakePossible?(id)
    (Group.where(:user_id => id).count() >= MAX_GROUP) ? false : true
  end

  def recentRegistrationUrls(grpid, limit)
    Crawlelist.where(:group_id => grpid).limit(limit).group("date(created_at)").count()
  end

  def recommendProcess(user, urlHash)
    uri = URI.parse(ENV['REDIS_URI'])
    Recommendify.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

    recommender = Recommender.new
    recommender.visits.add_set(user, [urlHash])
    recommender.process!
  end

end
