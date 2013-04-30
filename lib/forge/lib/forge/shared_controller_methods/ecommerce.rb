module Forge
  module Controllers
    module ECommerce
      def get_cart_order
        @cart_order = Order.where(:key => cookies[:order_key], :state => "pending").first if cookies[:order_key]
      end

      def require_addresses_for_checkout
        unless @cart_order.valid_addresses?
          redirect_to "orders/checkout"
          return false
        end
      end
    end
  end
end