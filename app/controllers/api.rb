Impas.controllers :api do

  # http://impas-hideack.sqale.jp/api/group/[operation key]
  post :group, :with => :opkey do
    checkOpKey(params[:opkey]) do
      passedJson = request.body.read.force_encoding("utf-8")
      return 400 if !validateJsonCommand('post_group', passedJson)

      command = parseCommand(passedJson)
      user = User.find_by_opkey(params[:opkey])

      # Group added.
      hashseed = "#{command["name"]}-impasgrp-#{Time.now.to_i}"
      
      grp = Group.new
      grp.userid = user.id
      grp.key = Digest::MD5.new.update(hashseed).to_s
      grp.name = command["name"]
      grp.save

      # API response
      generateResponse(true, "", {})
    end
  end


  # http://impas-hideack.sqale.jp/api/group/[operation key]
  get :group, :with => :opkey do
    checkOpKey(params[:opkey]) do
      user = User.find_by_opkey(params[:opkey])
      groups = []

      Group.where(:userid => user.id).each{|grp|
        groups << {name:grp.name, key:grp.key}
      }

      # API response
      generateResponse(true, "", {groups:groups})
    end
  end

  # http://impas-hideack.sqale.jp/api/url/[group key]/[url]
  post :registration, :with => [:key] do
    checkKey(params[:key]) do
      passedJson = request.body.read.force_encoding("utf-8")
      return 400 if !validateJsonCommand('post_registration', passedJson)

      comm = parseCommand(passedJson)

      url = comm["url"]
      urlhash = Digest::SHA1.new.update(url).to_s

      grp = Group.find_by_key(params[:key])

      # URL registration
      urlProp = Url.find_by_urlhash(urlhash)

      if urlProp.nil?
        urlProp = Url.new
        urlProp.url = url
        urlProp.urlhash = urlhash
        urlProp.save
      end

      # Crawle list registration
      crawlelist = Crawlelist.find_by_userid_and_urlid_and_groupid(grp.userid, urlProp.id, grp.id)

      if crawlelist.nil?
        crawlelist = Crawlelist.new
        crawlelist.userid = grp.userid
        crawlelist.urlid  = urlProp.id
        crawlelist.groupid = grp.id
        crawlelist.callcount = 1
      else
        crawlelist.callcount = crawlelist.callcount + 1
      end

      crawlelist.save

      # API response
      generateResponse(true, "", {})
    end
  end


  get :ranking, :with => [:key, :type, :limit] do
  end
end
