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

      order = 'crawlelists.id asc'

      case params[:order]
        when 'all_desc'
          order = 'crawlelists.id desc'
        when 'tw_desc'
          order = 'tw desc'
        when 'fb_desc'
          order = 'fb desc'
        when 'hatena_desc'
          order = 'hatena desc'
        when 'callcount_desc'
          order = 'callcount desc'
        when 'tw_asc'
          order = 'tw asc'
        when 'fb_asc'
          order = 'fb asc'
        when 'hatena_asc'
          order = 'hatena asc'
        when 'callcount_asc'
          order = 'callcount asc'
      end

      @urls = Url.select([:url, :tw, :fb, :hatena, :callcount]).joins(:crawlelists).where('crawlelists.group_id=?', @grp.id).order(order).page(params[:page] || 1).per(20)

      render "user/group", :locals=>{user: session[:user]}
    end
  end

end
