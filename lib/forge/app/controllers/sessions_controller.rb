class SessionsController < Devise::SessionsController
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    render :template => "devise/sessions/new"
  end

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    if resource.approved?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :warning, :not_approved
      redirect_to "/login"
    end
  end

  def destroy
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :signed_out if signed_in

    respond_to do |format|
      format.any(*navigational_formats) { redirect_to "/login" }
      format.all do
        method = "to_#{request_format}"
        text = {}.respond_to?(method) ? {}.send(method) : ""
        render :text => text, :status => :ok
      end
    end
  end
end
