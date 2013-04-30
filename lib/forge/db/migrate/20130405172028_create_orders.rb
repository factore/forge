class CreateOrders < ActiveRecord::Migration
  def up
    create_table "orders" do |t|
      t.string   "key"
      t.string   "state",               :default => "pending"
      t.integer  "billing_address_id"
      t.integer  "shipping_address_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.float    "shipping_cost"
    end

    add_index "orders", ["billing_address_id"], :name => "index_orders_on_billing_address_id"
    add_index "orders", ["created_at"], :name => "index_orders_on_created_at"
    add_index "orders", ["key"], :name => "index_orders_on_key", :unique => true
    add_index "orders", ["shipping_address_id"], :name => "index_orders_on_shipping_address_id"
  end

  def down
    drop_table :orders
  end
end