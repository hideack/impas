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
      grp.user_id = user.id
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

      Group.where(:user_id => user.id).each{|grp|
        groups << {name:grp.name, key:grp.key}
      }

      # API response
      generateResponse(true, "", {groups:groups})
    end
  end

  # http://impas-hideack.sqale.jp/api/registration/[group key]
  post :registration, :with => [:key] do
    checkKey(params[:key]) do
      passedJson = request.body.read.force_encoding("utf-8")
      return 400 if !validateJsonCommand('post_registration', passedJson)

      comm = parseCommand(passedJson)

      url = comm["url"]

      # URL format check.
      begin
        if (URI::HTTP === URI(url)) or (URI::HTTP === URI(url))
          #
        else
          return generateResponse(false, "Invalid URL passed.", {})
        end
      rescue
        return generateResponse(false, "Invalid URL passed.", {})
      end

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
      crawlelist = Crawlelist.find_by_user_id_and_url_id_and_group_id(grp.user_id, urlProp.id, grp.id)

      if crawlelist.nil?
        crawlelist = Crawlelist.new
        crawlelist.user_id = grp.user_id
        crawlelist.url_id  = urlProp.id
        crawlelist.group_id = grp.id
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
