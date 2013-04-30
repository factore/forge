class CreateProducts < ActiveRecord::Migration
  def up
    create_table "products" do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "title"
      t.string   "short_description"
      t.text     "description"
      t.float    "price",               :default => 0.0,   :null => false
      t.integer  "list_order"
      t.boolean  "featured",            :default => false, :null => false
      t.boolean  "published",           :default => false
      t.integer  "product_category_id"
      t.float    "weight",              :default => 0.0
      t.float    "flat_rate_shipping",  :default => 0.0
      t.float    "width",               :default => 0.0
      t.float    "height",              :default => 0.0
      t.float    "depth",               :default => 0.0
      t.text     "options"
      t.integer  "sale_id"
      t.string   "seo_title"
      t.text     "seo_keywords"
      t.text     "seo_description"
    end

    add_index "products", ["list_order"], :name => "index_products_on_list_order"
    add_index "products", ["product_category_id"], :name => "index_products_on_product_category_id"
    add_index "products", ["sale_id"], :name => "index_products_on_sale_id"
  end

  def down
    drop_table :products
  end
end