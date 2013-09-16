# File: lib/forge/ecommerce.rb
# Adds configuration options for ecommerce
# eg.
#
# Forge.configure do |config|
#   config.ecommerce.payments = :hosted or :integrated
#   config.ecommerce.shippers = {
#     :one => One,
#     :two => Two
#   }
#
#   config.ecommerce.active_merchant = {
#     :gateway  => "gateway",
#     :login    => "login",
#     :password => "password"
#   }
#
#   config.ecommerce.email_receipt = true
#
#   config.ecommerce.currency = "CAD"
#
#   config.ecommerce.paypal_production = {
#     :account => {}
#   }
#
#   config.ecommerce.paypal_sandbox = {
#     :account => {}
#   }
# end

module Forge
  class Configuration
    def ecommerce
      @ecommerce ||= EcommerceConfiguration.new
    end

    class EcommerceConfiguration
      attr_accessor :payments, :flat_rate_shipping, :shippers,
                    :email_receipt, :active_merchant, :paypal_production,
                    :paypal_sandbox, :currency

      def initialize
        @payments = :hosted
        @shippers           = {}
        @active_merchant    = {}
        @paypal_production  = {}
        @paypal_sandbox     = {}
      end

      def payments
        @payments.to_sym
      end
    end
  end
end
