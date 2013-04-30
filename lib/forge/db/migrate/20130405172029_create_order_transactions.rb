class CreateOrderTransactions < ActiveRecord::Migration
  def up
    create_table "order_transactions" do |t|
      t.integer  "order_id"
      t.integer  "amount"
      t.boolean  "success"
      t.string   "reference"
      t.string   "message"
      t.string   "action"
      t.text     "params"
      t.boolean  "test"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "order_transactions", ["order_id"], :name => "index_order_transactions_on_order_id"
  end

  def down
    drop_table :order_transactions
  end
end