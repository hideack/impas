# Helper methods defined here can be accessed in any controller or view in the application
require 'json'

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
end
