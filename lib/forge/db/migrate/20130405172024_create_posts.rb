class CreatePosts < ActiveRecord::Migration
  def up
    create_table "posts", :force => true do |t|
      t.string   "title"
      t.text     "content"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "allow_comments",  :default => true,  :null => false
      t.integer  "creator_id"
      t.integer  "updater_id"
      t.boolean  "published",       :default => false
      t.text     "excerpt"
      t.string   "seo_title"
      t.text     "seo_keywords"
      t.text     "seo_description"
    end

    add_index "posts", ["created_at"], :name => "index_posts_on_created_at"
    add_index "posts", ["creator_id"], :name => "index_posts_on_creator_id"
    add_index "posts", ["updater_id"], :name => "index_posts_on_updater_id"
    add_index "posts", ["user_id"], :name => "index_posts_on_user_id"
  end

  def down
    drop_table :posts
  end
end