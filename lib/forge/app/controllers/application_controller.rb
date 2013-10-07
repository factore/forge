class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  layout :layout_by_resource
  before_filter :app_init

  def app_init
    # application-wide init stuff here
    @menu_items = Page.find_for_menu
  end

  private

  protected
    def layout_by_resource
      if devise_controller?
        "forge_login"
      else
        "application"
      end
    end

    def after_sign_in_path_for(resource)
      if resource.staff?
        '/forge'
      else
        super
      end
    end

    def require_admin
      unless current_user && current_user.staff?
        flash[:warning] = "You're not authorized for that." if current_user
        redirect_to '/login'
      end
    end
end
