class OrderTransaction < ActiveRecord::Base
  belongs_to :order
  serialize :params

  class << self
    def authorize(amount, credit_card, options = {})
      process('authorization', amount) do |gw|
        gw.authorize(amount, credit_card, options)
      end
    end

    def capture(amount, authorization, options = {})
      process('capture', amount) do |gw|
        gw.capture(amount, authorization, options)
      end
    end

    private

    def process(action, amount = nil)
      result = OrderTransaction.new
      result.amount = amount
      result.action = action

      begin
        # TODO: is eval appropriate in this instance?  I tried Object.const_get but had problems.
        # OPTIMIZE: this is a bit crufty
        am_setting = Forge::Settings[Rails.env.to_sym][:active_merchant]
        gateway_class = eval("ActiveMerchant::Billing::" + am_setting[:gateway])
        gateway = gateway_class.new(:login => am_setting[:login], :password => am_setting[:password])
        response = yield gateway

        result.success   = response.success?
        result.reference = response.authorization
        result.message   = response.message
        result.params    = response.params
        result.test      = response.test?
      rescue ActiveMerchant::ActiveMerchantError => e
        result.success   = false
        result.reference = nil
        result.message   = e.message
        result.params    = {}
        result.test      = gateway.test?
      end

      result
    end
  end

end
