Impas.controllers :auth do
  # http://impas-hideack.sqale.jp/auth
  get :index do 
    url = oauthClient.auth_code.authorize_url(:redirect_uri => AUTH_REDIRECT_URL, :scope => 'user,public_repo')
    puts "Redirecting to URL: #{url.inspect}"
    redirect url
  end

  # http://impas-hideack.sqale.jp/auth/callback
  get :callback do
    begin
      access_token = oauthClient.auth_code.get_token(params[:code], :redirect_uri => AUTH_REDIRECT_URL)
      user = JSON.parse(access_token.get('/user').body)

      # ユーザ管理
      reguser = User.find_by_name(user["name"])

      if reguser.nil?
        hashseed = "#{user["name"]}-impas-#{Time.now.to_i}"

        reguser = User.new
        reguser.name = user["name"]
        reguser.opkey = Digest::MD5.new.update(hashseed).to_s
        reguser.usertype = 0
        reguser.save
      end

      session[:user] = reguser

    rescue OAuth2::Error => e
      %(<p>Outdated ?code=#{params[:code]}:</p><p>#{$!}</p><p><a href="/auth/github">Retry</a></p>)
    end

    redirect "/user"
  end

  get :logout do
    session.delete(:user)
  end

  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  
end
