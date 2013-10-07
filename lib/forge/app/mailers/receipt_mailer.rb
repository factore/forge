class ReceiptMailer < ActionMailer::Base
  helper ApplicationHelper

  default from: Proc.new { MySettings.receipt_email }
  
  def receipt(order)
    @order = order
    if MySettings.bcc_receipt_email.blank?
      mail(:to => @order.billing_address.email, :subject => "#{MySettings.site_title} :: Receipt for your order")
    else
      mail(:to => @order.billing_address.email, :bcc => MySettings.bcc_receipt_email, :subject => "#{MySettings.site_title} :: Receipt for your order")
    end
  end

end
