class CreateBanners < ActiveRecord::Migration
  def up
    create_table "banners" do |t|
      t.string   "title"
      t.string   "photo_file_name"
      t.string   "photo_content_type"
      t.integer  "photo_file_size"
      t.boolean  "published",          :default => true
      t.integer  "list_order",         :default => 999
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "banners", ["list_order"], :name => "index_banners_on_list_order"
  end

  def down
    drop_table :banners
  end
end