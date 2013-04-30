class CreateProductImages < ActiveRecord::Migration
  def up
    create_table "product_images" do |t|
      t.integer  "product_id"
      t.integer  "image_file_size"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "list_order"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "product_images", ["list_order"], :name => "index_product_images_on_list_order"
    add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"
  end

  def down
    drop_table :product_images
  end
end