class Forge::SettingsController < ForgeController
  def update
    force_boolean(params[:settings])
    params[:settings].each { |key, value| MySettings.send((key + '=').to_sym, value) }
    flash[:notice] = "Your settings have been saved."
    redirect_to forge_settings_path
  end

  def show
    @carriers = ActiveMerchant::Shipping::Carriers.all.delete_if { |c| c.name =~ /Bogus/ }
    @settings = MySettings
    @tab = params[:tab] == 'video' ? 1 : 0
  end

  private
    # we want some settings to be typecast into boolean values
    def force_boolean(settings)
      [:ecommerce_live, :use_coupons, :flat_rate_shipping, :integrated_payments].each do |key|
        if settings[key] == "true"
          settings[key] = true
        else
          settings[key] = false
        end
      end
    end
end
