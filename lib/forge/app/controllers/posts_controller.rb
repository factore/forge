class PostsController < ApplicationController
  before_filter :get_archive_months, :only => [:index, :category, :show]
  before_filter :get_post_categories

  def index
    @page_title = "Latest News"
    @posts = Post.posted
    if params[:month] && params[:year] # get posts based on archive month
      start_date = Time.parse("#{params[:year]}-#{params[:month]}-01")
      end_date = start_date + 1.month
      @posts = Post.posted.where("created_at >= ? AND created_at <= ?", start_date, end_date)
      @page_title += " | #{start_date.strftime("%B %Y")}"
    end
    @posts = @posts.paginate(:per_page => 6, :page => params[:page])
    session[:page] = params[:page] if params[:page]

    respond_to do |format|
      format.html {}
    end
  end

  def category
    @post_category = PostCategory.find(params[:id])
    @page_title = "Latest News | " + @post_category.title
    @posts = @post_category.posts.posted.paginate(:per_page => 6, :page => params[:page])
    session[:page] = params[:page] if params[:page]
    render :template => "posts/index"
  end

  def show
    @post, @page_title = get_post
    flash.now[:notice] = "This post is not yet posted and will not appear on your live website." unless @post.posted?
    @comment = Comment.create_comment(@post, session[:comment]) if @post.allow_comments?
    respond_to do |format|
      format.html {}
    end
  end

  def feed
    @posts = Post.posted.all(:order => "created_at DESC", :limit => 10)
    respond_to do |format|
      format.rss
    end
  end

  def preview
    @post = Post.new(params[:post])
    render :action => :show
  end

  private
    def get_post
      post = current_user.blank? ? Post.posted.find(params[:id]) : Post.find(params[:id])
      page_title = post.seo_title.blank? ? post.title : post.seo_title
      return post, page_title
    end

end
