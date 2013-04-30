class CreateGalleries < ActiveRecord::Migration
  def up
    create_table "galleries" do |t|
      t.string   "title"
      t.integer  "list_order"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "photos" do |t|
      t.integer  "gallery_id"
      t.integer  "list_order"
      t.string   "title"
      t.integer  "file_file_size"
      t.string   "file_file_name"
      t.string   "file_content_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "photos", ["gallery_id"], :name => "index_photos_on_gallery_id"
    add_index "photos", ["list_order"], :name => "index_photos_on_list_order"
  end

  def down
    drop_table :galleries
    drop_table :photos
  end
end