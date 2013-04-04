# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130212205702) do

  create_table "addresses", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "postal"
    t.integer  "country_id"
    t.string   "phone"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "province_id"
    t.string   "company"
  end

  add_index "addresses", ["country_id"], :name => "index_addresses_on_country_id"
  add_index "addresses", ["province_id"], :name => "index_addresses_on_province_id"
  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "assets", :force => true do |t|
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

  create_table "banners", :force => true do |t|
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

  create_table "comment_subscribers", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comment_subscribers", ["commentable_id"], :name => "index_comment_subscribers_on_commentable_id"
  add_index "comment_subscribers", ["commentable_type"], :name => "index_comment_subscribers_on_commentable_type"

  create_table "comments", :force => true do |t|
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

  create_table "countries", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.boolean  "top_of_list", :default => false, :null => false
    t.boolean  "active",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["code"], :name => "index_countries_on_code", :unique => true
  add_index "countries", ["title"], :name => "index_countries_on_title"
  add_index "countries", ["top_of_list"], :name => "index_countries_on_top_of_list"

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

  create_table "dispatch_bounces", :force => true do |t|
    t.integer  "dispatch_id"
    t.integer  "subscriber_id"
    t.string   "bounce_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dispatch_bounces", ["dispatch_id"], :name => "index_dispatch_bounces_on_dispatch_id"
  add_index "dispatch_bounces", ["subscriber_id"], :name => "index_dispatch_bounces_on_subscriber_id"

  create_table "dispatch_link_clicks", :force => true do |t|
    t.integer  "dispatch_link_id"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dispatch_link_clicks", ["dispatch_link_id"], :name => "index_dispatch_link_clicks_on_dispatch_link_id"

  create_table "dispatch_links", :force => true do |t|
    t.integer  "dispatch_id"
    t.string   "uri"
    t.integer  "position"
    t.integer  "clicks_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dispatch_links", ["clicks_count"], :name => "index_dispatch_links_on_clicks_count"
  add_index "dispatch_links", ["dispatch_id"], :name => "index_dispatch_links_on_dispatch_id"

  create_table "dispatch_opens", :force => true do |t|
    t.integer  "dispatch_id"
    t.string   "email"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dispatch_opens", ["created_at"], :name => "index_dispatch_opens_on_created_at"
  add_index "dispatch_opens", ["dispatch_id"], :name => "index_dispatch_opens_on_dispatch_id"

  create_table "dispatch_unsubscribes", :force => true do |t|
    t.integer  "dispatch_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dispatch_unsubscribes", ["dispatch_id"], :name => "index_dispatch_unsubscribes_on_dispatch_id"

  create_table "dispatches", :force => true do |t|
    t.string   "subject"
    t.text     "content"
    t.datetime "sent_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "queued_message_count"
    t.integer  "sent_message_count"
    t.integer  "failed_message_count"
    t.integer  "opened_message_count"
    t.text     "display_content"
  end

  add_index "dispatches", ["creator_id"], :name => "index_dispatches_on_creator_id"
  add_index "dispatches", ["updater_id"], :name => "index_dispatches_on_updater_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "location"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "published",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries", :force => true do |t|
    t.string   "title"
    t.integer  "list_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "help_topics", :force => true do |t|
    t.string   "language",   :default => "en", :null => false
    t.string   "slug",                         :null => false
    t.string   "title",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
  end

  add_index "help_topics", ["title"], :name => "index_help_topics_on_title"

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.float    "price"
    t.integer  "quantity",   :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"

  create_table "order_transactions", :force => true do |t|
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

  create_table "orders", :force => true do |t|
    t.string   "key"
    t.string   "state",               :default => "pending"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "shipping_cost"
  end

  add_index "orders", ["billing_address_id"], :name => "index_orders_on_billing_address_id"
  add_index "orders", ["created_at"], :name => "index_orders_on_created_at"
  add_index "orders", ["key"], :name => "index_orders_on_key", :unique => true
  add_index "orders", ["shipping_address_id"], :name => "index_orders_on_shipping_address_id"

  create_table "pages", :force => true do |t|
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

  create_table "photos", :force => true do |t|
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

  create_table "post_categories", :force => true do |t|
    t.string   "title"
    t.integer  "list_order", :default => 999
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_categories_posts", :id => false, :force => true do |t|
    t.integer "post_category_id"
    t.integer "post_id"
  end

  add_index "post_categories_posts", ["post_category_id"], :name => "index_post_categories_posts_on_post_category_id"
  add_index "post_categories_posts", ["post_id"], :name => "index_post_categories_posts_on_post_id"

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

  create_table "product_categories", :force => true do |t|
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

  create_table "product_images", :force => true do |t|
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

  create_table "products", :force => true do |t|
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

  create_table "products_tax_rates", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "tax_rate_id"
  end

  add_index "products_tax_rates", ["product_id"], :name => "index_products_tax_rates_on_product_id"
  add_index "products_tax_rates", ["tax_rate_id"], :name => "index_products_tax_rates_on_tax_rate_id"

  create_table "provinces", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["code"], :name => "index_provinces_on_code"
  add_index "provinces", ["country_id"], :name => "index_provinces_on_country_id"
  add_index "provinces", ["title"], :name => "index_provinces_on_title"

  create_table "queued_dispatches", :force => true do |t|
    t.integer  "dispatch_id"
    t.integer  "subscriber_id"
    t.datetime "sent_at"
    t.integer  "failed_attempts",     :default => 0
    t.datetime "opened_at"
    t.datetime "last_failed_attempt"
    t.text     "last_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "queued_dispatches", ["dispatch_id"], :name => "index_queued_dispatches_on_dispatch_id"
  add_index "queued_dispatches", ["subscriber_id"], :name => "index_queued_dispatches_on_subscriber_id"

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sales", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "start"
    t.datetime "end"
    t.float    "value"
    t.string   "sale_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "subscriber_group_members", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriber_group_members", ["group_id"], :name => "index_subscriber_group_members_on_group_id"
  add_index "subscriber_group_members", ["subscriber_id"], :name => "index_subscriber_group_members_on_subscriber_id"

  create_table "subscriber_groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
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

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tax_rates", :force => true do |t|
    t.string   "title"
    t.float    "rate",        :default => 0.0, :null => false
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "province_id"
  end

  add_index "tax_rates", ["country_id"], :name => "index_tax_rates_on_country_id"
  add_index "tax_rates", ["province_id"], :name => "index_tax_rates_on_province_id"

  create_table "time_tests", :force => true do |t|
    t.string   "title"
    t.datetime "starts_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
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

  create_table "video_feeds", :force => true do |t|
    t.string   "title"
    t.string   "channel"
    t.string   "video_id"
    t.string   "thumbnail_url"
    t.string   "source"
    t.boolean  "published",     :default => true
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "video_feeds", ["published_at"], :name => "index_video_feeds_on_published_at"
  add_index "video_feeds", ["video_id"], :name => "index_video_feeds_on_video_id"

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encoded_state"
    t.string   "mobile_encoded_state"
    t.string   "output_url"
    t.string   "mobile_output_url"
    t.integer  "job_id"
    t.text     "description"
    t.boolean  "published",              :default => true
    t.boolean  "allow_comments",         :default => true
  end

  add_index "videos", ["job_id"], :name => "index_videos_on_job_id"
  add_index "videos", ["user_id"], :name => "index_videos_on_user_id"

end
