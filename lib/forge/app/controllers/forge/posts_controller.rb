class Forge::PostsController < ForgeController
  before_filter :get_collections
  before_filter :uses_ckeditor, :only => [:new, :update, :create, :edit]
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html { @posts = Post.paginate(:per_page => 10, :page => params[:page]) }
      format.js  {
        @posts = Post.where("title LIKE :q OR content LIKE :q", {:q => "%#{params[:q]}%"})
        render :partial => "post", :collection => @posts
      }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def new
    @post = Post.new
    @help = HelpTopic.where(:slug => "posts_new").first
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  def edit
  end

  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to(forge_posts_path, :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    params[:post][:post_category_ids] ||= []
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(forge_posts_path, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(forge_posts_path) }
      format.xml  { head :ok }
    end
  end

  private
    def get_collections
      @categories = PostCategory.order(:title)
    end
end
