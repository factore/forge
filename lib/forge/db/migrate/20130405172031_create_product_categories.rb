class CreateProductCategories < ActiveRecord::Migration
  def up
    create_table "product_categories" do |t|
      t.string   "title"
      t.integer  "list_order", :default => 999
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "parent_id"
      t.integer  "sale_id"
    end

    add_index "product_categories", ["list_order"], :name => "index_product_categories_on_list_order"
    add_index "product_categories", ["parent_id"], :name => "index_product_categories_on_parent_id"
    add_index "product_categories", ["sale_id"], :name => "index_product_categories_on_sale_id"
  end

  def down
    drop_table :product_categories
  end
end