class CreatePages < ActiveRecord::Migration
  def up
    create_table "pages" do |t|
      t.integer  "parent_id"
      t.string   "title"
      t.string   "slug"
      t.string   "path"
      t.string   "unique_key"
      t.text     "content"
      t.integer  "list_order",      :default => 999
      t.boolean  "show_in_menu",    :default => true
      t.integer  "creator_id"
      t.integer  "updater_id"
      t.boolean  "published"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "key"
      t.string   "seo_title"
      t.text     "seo_description"
      t.text     "seo_keywords"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth"
    end

    add_index "pages", ["creator_id"], :name => "index_pages_on_creator_id"
    add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
    add_index "pages", ["slug"], :name => "index_pages_on_slug"
    add_index "pages", ["updater_id"], :name => "index_pages_on_updater_id"
  end

  def down
    drop_table :pages
  end
end
