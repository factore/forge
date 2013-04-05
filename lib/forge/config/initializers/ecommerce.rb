# tell Active Shipping to use metric units by default
ActiveMerchant::Shipping::Package.default_options = { :units => :metric }
if Forge::Settings[Rails.env.to_sym][:active_merchant]
  ActiveMerchant::Billing::Base.mode = Forge::Settings[Rails.env.to_sym][:active_merchant][:base_mode].to_sym
end