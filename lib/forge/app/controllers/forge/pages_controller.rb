class Forge::PagesController < ForgeController
  load_and_authorize_resource
  before_filter :get_potential_parents, :only => [:new, :edit, :update, :create]
  before_filter :uses_ckeditor, :only => [:new, :edit, :update, :create]
  cache_sweeper :page_sweeper, :only => [:update, :create, :destroy, :reorder]


  def index
    respond_to do |format|
      format.html {
        @pages = @pages.order(:lft)
      }
      format.js {
        ids = Page.where("title LIKE :q OR content LIKE :q", {:q => "%#{params[:q]}%"}).collect {|p| p.top_parent.id}
        @pages = Page.top.where("id IN (?)", ids)
        render :partial => "page", :collection => @pages
      }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def new
    @page = Page.new(:parent_id => params[:parent_id])
    @help = HelpTopic.where(:slug => "pages_add").first
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  def edit
  end

  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to(forge_pages_path, :notice => 'Page was successfully created.') }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to(forge_pages_path, :notice => 'Page was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to(forge_pages_path) }
      format.xml  { head :ok }
    end
  end

  def reorder
    Page.reorder!(params[:page_list], params[:parent_id])
    render :nothing => true
  end

  private
    def get_potential_parents
      id = params[:id] || 0
      @potential_parents = Page.order(:lft)
    end
end
