class ForgeController < ApplicationController
  before_filter :require_admin, :load_help, :get_menu_items, :set_crumbs, :set_title
  layout 'forge'

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to '/forge'
  end

  def uses_ckeditor
    @uses_ckeditor = true
  end

  def load_help
    @help_slug = "#{params[:controller].split('/')[1]}_#{params[:action]}"
  end

  def get_menu_items
    # TODO: we're really not supposed to be reading the routes like this
    # Read the routes to find out which partials to load to build the menu
    routes = Rails.application.routes.routes
    inspector = ActionDispatch::Routing::RoutesInspector.new(routes)
    formatter = ActionDispatch::Routing::ConsoleFormatter.new
    controllers = inspector.format(formatter).split("\n").select do |route|
      route.match('forge')
    end.map do |route|
      route.gsub(/.*\)\s+/,'').gsub("forge/","").gsub(/#.*/, "")
    end
    @menu_items = controllers.reject {|c| c == "index"}.uniq!
  end

  def set_crumbs
    @controller_crumb = params[:controller]
    @action_crumb = params[:action]
  end

  def set_title
    case params[:action]
      when "new", "create"
        @page_title = "New #{params[:controller].gsub('forge/', '').singularize.humanize} - Forge".titleize
      when "edit", "update"
        @page_title = "Edit #{params[:controller].gsub('forge/', '').singularize.humanize} - Forge".titleize
      else
        @page_title = params[:controller].gsub('forge/', '').humanize.titleize + " - Forge"
      end
    @page_title = "Forge" if params[:controller].gsub('forge/', '') == "index"
  end
end
