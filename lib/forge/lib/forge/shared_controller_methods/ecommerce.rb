module Forge
  module Controllers
    module Ecommerce
      def get_cart_order
        @cart_order = Order.where("orders.key = ? AND (orders.state = 'pending' OR orders.state = 'failed')", cookies[:order_key]).first if cookies[:order_key]
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
