Impas.controllers :user do
  before do
    if session[:user].nil?
      redirect "/"
    end
  end

  # http://impas-hideack.sqale.jp/user
  get :index do
    @groups = Group.where(:user_id => session[:user].id)
    render "user/index", :locals=>{user: session[:user]}
  end

  # http://impas-hideack.sqale.jp/user/group/(grp key)
  get :group, :with => [:key] do
    checkKey(params[:key]) do
      @grp = Group.find_by_key(params[:key])

      if @grp.user_id != session[:user].id
        return 404
      end

      @urls = Url.select([:url, :tw, :fb, :hatena, :callcount]).joins(:crawlelists).where('crawlelists.group_id=?', @grp.id).page(params[:page] || 1).per(20)

      render "user/group", :locals=>{user: session[:user]}
    end
  end

end
