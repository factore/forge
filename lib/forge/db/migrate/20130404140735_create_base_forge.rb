class CreateBaseForge < ActiveRecord::Migration
  def up
    create_table "assets" do |t|
      t.string   "title"
      t.string   "attachment_file_name"
      t.string   "attachment_content_type"
      t.integer  "attachment_file_size"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "encoded_state"
      t.string   "output_url"
      t.string   "aspect_ratio"
      t.integer  "duration_in_ms"
      t.integer  "job_id"
    end

    add_index "assets", ["created_at"], :name => "index_assets_on_created_at"
    add_index "assets", ["job_id"], :name => "index_assets_on_job_id"

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

    create_table "delayed_jobs", :force => true do |t|
      t.integer  "priority",   :default => 0
      t.integer  "attempts",   :default => 0
      t.text     "handler"
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "queue"
    end

    add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

    create_table "help_topics" do |t|
      t.string   "language",   :default => "en", :null => false
      t.string   "slug",                         :null => false
      t.string   "title",                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "content"
    end

    add_index "help_topics", ["title"], :name => "index_help_topics_on_title"


    create_table "settings" do |t|
      t.string   "var",                      :null => false
      t.text     "value"
      t.integer  "thing_id"
      t.string   "thing_type", :limit => 30
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

    create_table "roles" do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles_users", :id => false do |t|
      t.integer "user_id"
      t.integer "role_id"
    end

    add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
    add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

    create_table "taggings" do |t|
      t.integer  "tag_id"
      t.integer  "taggable_id"
      t.string   "taggable_type"
      t.integer  "tagger_id"
      t.string   "tagger_type"
      t.string   "context"
      t.datetime "created_at"
    end

    add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
    add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

    create_table "tags" do |t|
      t.string "name"
    end

    create_table "users" do |t|
      t.string   "email",                                 :default => "",    :null => false
      t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                         :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "avatar_file_name"
      t.string   "avatar_content_type"
      t.integer  "avatar_file_size"
      t.boolean  "approved",                              :default => false
      t.datetime "reset_password_sent_at"
    end

    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

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
    drop_table :assets
    drop_table :comment_subscribers
    drop_table :comments
    drop_table :help_topics
    drop_table :settings
    drop_table :roles
    drop_table :roles_users
    drop_table :tags
    drop_table :taggings
    drop_table :users
    drop_table :pages
  end
end
