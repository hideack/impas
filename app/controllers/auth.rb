Impas.controllers :auth do
  get :index do 
    url = oauthClient.auth_code.authorize_url(:redirect_uri => AUTH_REDIRECT_URL, :scope => 'user,public_repo')
    puts "Redirecting to URL: #{url.inspect}"
    redirect url
  end

  # http://impas-hideack.sqale.jp/auth/callback
  get :callback do
    redirectUrl = "http://local.impas-hideack.sqale.jp/auth/callback"
    puts params[:code]

    begin
      access_token = oauthClient.auth_code.get_token(params[:code], :redirect_uri => AUTH_REDIRECT_URL)
      user = JSON.parse(access_token.get('/user').body)
      "<p>Your OAuth access token: #{access_token.token}</p><p>Your extended profile data:\n#{user.inspect}</p>"
    rescue OAuth2::Error => e
      %(<p>Outdated ?code=#{params[:code]}:</p><p>#{$!}</p><p><a href="/auth/github">Retry</a></p>)
    end
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
