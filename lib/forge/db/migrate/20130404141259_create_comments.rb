class CreateComments < ActiveRecord::Migration
  def up
    create_table "comment_subscribers" do |t|
      t.integer  "commentable_id"
      t.string   "commentable_type"
      t.string   "email"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "comment_subscribers", ["commentable_id"], :name => "index_comment_subscribers_on_commentable_id"
    add_index "comment_subscribers", ["commentable_type"], :name => "index_comment_subscribers_on_commentable_type"

    create_table "comments" do |t|
      t.string   "author"
      t.string   "author_url"
      t.string   "author_email"
      t.text     "content"
      t.string   "permalink"
      t.string   "user_ip"
      t.string   "user_agent"
      t.string   "referrer"
      t.integer  "commentable_id"
      t.boolean  "approved",         :default => false, :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "commentable_type"
    end

    add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
    add_index "comments", ["commentable_id"], :name => "index_comments_on_post_id"
    add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
    add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  end

  def down
    drop_table :comment_subscribers
    drop_table :comments
  end
end
