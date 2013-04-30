# SHOPPING & E-ECOMMERCE - FRONT END
# ==================================

# Order routes
# ------------
# new & create: not used, orders are created automatically when user commences shopping.
# edit & update: refers to the contents of the order (the line items)
# checkout: let's the user view their order, make any changes as needed before paying

# Line item routes
# ----------------
# These belong to orders and are handled as additions or removals from orders, as such, they don't
# really need all of the standard views and actions.

resources :products, :only => [:index, :show] do
  collection do
    get :preview
  end
end

resources :addresses, :except => [:index, :show, :destroy]

resources :orders, :only => [:update] do
  member do
    delete 'remove_from_cart'
    get 'paid'
  end
  collection do
    post 'add_to_cart'
    get 'cancel', 'get_cart'
  end
end

match 'orders/checkout' => 'orders#checkout_get', :via => :get
match 'orders/checkout' => 'orders#checkout_post', :via => :post

get "integrated_payment/billing"
post "integrated_payment/pay"
get "hosted_payment/billing"
post "hosted_payment/notify"

# END SHOPPING & E-ECOMMERCE - FRONT END
# ======================================