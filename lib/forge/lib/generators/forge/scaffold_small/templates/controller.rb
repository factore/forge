<% files = attributes.select {|a| a.name.match(/_content_type|_file_size|_file_name/)}.map {|a| a.name.split('_')[0..-3].join('_')}.uniq -%>
<% collections = attributes.select {|a| a.name.match(/_id$/)}.map {|a| a.name.gsub(/_id$/, '')}.uniq -%>
class Forge::<%= class_name.pluralize %>Controller < ForgeController
  load_and_authorize_resource
<% unless attributes.select {|a| a.field_type.to_s == "text_area"}.empty? -%>
  before_filter :uses_ckeditor, :only => [:edit, :update, :new, :create]
<% end -%>
<% unless collections.blank? -%>
  before_filter :get_collections, :only => [:index, :edit, :update, :new, :create]
<% end -%>

  def index
    respond_to do |format|
      format.html {
        @<%= plural_table_name %> = <%= class_name %><%= ".order(:list_order)" unless attributes.select{|a| a.name == "list_order" }.empty? %>.paginate(:per_page => 10, :page => params[:page])
        @<%= singular_name %> = <%= class_name %>.new
      }
      format.js {
        params[:q] ||= ''
        @<%= plural_table_name %> = <%= class_name %>.where("LOWER(title) LIKE ?", "%#{params[:q].downcase}%")
        render :partial => "<%= file_name %>", :collection => @<%= plural_table_name %>
      }
    end
  end

  def new
  end

  def edit
    respond_to do |format|
      format.html {}
      format.js { render :layout => false }
    end
  end

  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])
    if @<%= file_name %>.save
      flash[:notice] = '<%= class_name %> was successfully created.'
      redirect_to(forge_<%= plural_table_name %>_path)
    else
      render :action => "index"
    end
  end

  def update
<% files.each do |f| -%>
    @<%= file_name %>.<%= f %> = nil if params[:remove_asset] == "1"
<% end %>
    if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
      flash[:notice] = '<%= class_name %> was successfully updated.'
      redirect_to(forge_<%= plural_table_name %>_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @<%= file_name %>.destroy
    redirect_to(forge_<%= plural_table_name %>_path)
  end

<% unless attributes.select{|a| a.name == "list_order" }.empty? -%>
  def reorder
    <%= class_name %>.reorder!(params[:<%= file_name %>_list])

    respond_to do |format|
      format.js { render :nothing => true }
      format.html { redirect_to :action => :index }
    end
  end
<% end -%>
<% unless collections.blank? -%>
  private
    def get_collections
<% collections.each do |c| -%>
      @<%= c.pluralize %> = <%= c.camelize %>.all
<% end -%>
    end
<% end -%>
end
