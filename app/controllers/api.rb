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
      generateResponse(true, {})
    end
  end


  # http://impas-hideack.sqale.jp/api/group/[operation key]
  get :group, :with => :opkey do
  end

  # http://impas-hideack.sqale.jp/api/url/[group key]
  post :url, :with => [:key] do
  end

  # http://impas-hideack.sqale.jp/api/url/[group key]/[url]
  get :url, :with => [:key, :url] do
  end

  get :ranking, :with => [:key, :type, :limit] do
  end
end
