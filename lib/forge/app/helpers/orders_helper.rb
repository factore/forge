module OrdersHelper

  # prepends the paypal prefix to the order id
  def invoice_number_for_paypal(order)
    if MySettings.paypal_invoice_prefix.blank?
      order.id.to_s
    else
      MySettings.paypal_invoice_prefix + order.id.to_s
    end
  end

end
