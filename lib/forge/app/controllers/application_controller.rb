class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  layout :layout_by_resource
  before_filter :app_init
  before_filter :prepare_for_mobile if Forge.config.mobile_layout

  def app_init
    # application-wide init stuff here
    @mobile_menu_items = Page.find_for_menu if Forge.config.mobile_layout
  end

  private
    def mobile_device?
      if devise_controller? || controller_path.match(/forge/)
        false # default to non-mobile for login page and forge
      elsif session[:mobile_param]
        session[:mobile_param] == "1"
      else
        using_mobile_device?
      end
    end
    helper_method :mobile_device?

    def using_mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end
    helper_method :using_mobile_device?

    def prepare_for_mobile
      session[:mobile_param] = params[:mobile] if params[:mobile]
      request.format = :mobile if mobile_device?
    end

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
