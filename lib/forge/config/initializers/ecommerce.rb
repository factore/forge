# tell Active Shipping to use metric units by default
ActiveMerchant::Shipping::Package.default_options = { :units => :metric }
if Forge.config.ecommerce.active_merchant
  ActiveMerchant::Billing::Base.mode = Forge.config.ecommerce.active_merchant[:base_mode].to_sym
end