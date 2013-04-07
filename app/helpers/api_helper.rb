# Helper methods defined here can be accessed in any controller or view in the application
require 'json'
###require 'URI'
###require './recommender/recommender.rb'

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

  def visit_logging(grpid, visitor, urlid)
    # 累計訪問回数記録
    sum_count = Visitlog.sum(:visit_count, :conditions => {:group_id => grpid, :visitor => visitor})
    logger.info "Visit count sum=#{sum_count}"

    # 訪問者記録
    log = Visitlog.find(:first, :conditions => {:group_id => grpid, :visitor => visitor, :url_id => urlid})

    if log.nil?
      log = Visitlog.new
      log.group_id = grpid
      log.visitor = visitor
      log.url_id = urlid
    end

    current_count = log.visit_count
    log.visit_count = current_count + 1
    log.save!

    # 正規化
    normalize_sql = "UPDATE visitlogs SET normalize_count=visit_count/#{(sum_count + 1).to_f} WHERE group_id=#{grpid} and visitor=#{visitor}";
    abs_sql       = "UPDATE visitlogs SET normalize_abs=normalize_count * normalize_count WHERE group_id=#{grpid} and visitor=#{visitor}";
    ActiveRecord::Base.connection.execute(normalize_sql)
    ActiveRecord::Base.connection.execute(abs_sql)
    
  end

end
