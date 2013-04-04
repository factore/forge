class IntegratedPaymentController < ApplicationController
  before_filter :disallow_if_payment_is_hosted
  before_filter :get_cart_order
  before_filter :require_addresses_for_checkout

  def billing
    @user = current_user
    @page_title = "Pay Securely Online WIth Your Credit Card"
  end

  def pay
    processor = Forge::CreditCardProcessor.new(@cart_order)
    processor.create_credit_card(
      :number => params[:credit_card][:number],
      :verification_value => params[:credit_card][:verification_value],
      :month => params[:date][:month],
      :year => params[:date][:year]
    )
    if processor.pay(@cart_order)
      flash[:notice] = processor.message
      redirect_to paid_order_path(@cart_order, :key => @cart_order.key)
    else
      flash[:warning] = processor.message
      render :action => "billing" and return
    end
  end

  private

    def disallow_if_payment_is_hosted
      if !Forge::Settings[:integrated_payments]
        redirect_to "/hosted_payment/billing" and return false
      end
    end

end
