class HostedPaymentController < ApplicationController
  before_filter :disallow_if_payment_is_integrated
  protect_from_forgery :except => [:notify]
  before_filter :get_cart_order
  before_filter :require_addresses_for_checkout

  def billing
    @user = current_user
    @page_title = "Pay Securely Online With PayPal"
  end

  def notify
    order = Order.capture_payment(request.raw_post)
    render :nothing => true
  end

  private

    def disallow_if_payment_is_integrated
      if Forge::Settings[:integrated_payments]
        redirect_to "/integrated_payment/billing" and return false
      end
    end

end
