# Helper methods defined here can be accessed in any controller or view in the application

Impas.helpers do
	use Rack::Env if PADRINO_ENV == 'development'

  def oauthClient
  	#ENV['GITHUB_OAUTH_ID'] = "5757782b0547811caeae"
  	#ENV['GITHUB_OAUTH_SECRET'] = "f0f0afa34f45d4ff5012d5bd032bba3d1fec94ba"

    OAuth2::Client.new(ENV['GITHUB_OAUTH_ID'], ENV['GITHUB_OAUTH_SECRET'],
                       :ssl => {:verify => false},
                       :site => 'https://api.github.com',
                       :authorize_url => 'https://github.com/login/oauth/authorize',
                       :token_url => 'https://github.com/login/oauth/access_token')
  end

  def redirect_uri(path = '/auth/github/callback', query = nil)
    uri = URI.parse(request.url)
    uri.path  = path
    uri.query = query
    uri.to_s
  end
  # def simple_helper_method
  #  ...
  # end
end
