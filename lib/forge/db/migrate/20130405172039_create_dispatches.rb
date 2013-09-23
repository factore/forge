class CreateDispatches < ActiveRecord::Migration
  def up
    create_table "dispatch_bounces" do |t|
      t.integer  "dispatch_id"
      t.integer  "subscriber_id"
      t.string   "bounce_code"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "dispatch_bounces", ["dispatch_id"], :name => "index_dispatch_bounces_on_dispatch_id"
    add_index "dispatch_bounces", ["subscriber_id"], :name => "index_dispatch_bounces_on_subscriber_id"

    create_table "dispatch_link_clicks" do |t|
      t.integer  "dispatch_link_id"
      t.string   "ip"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "dispatch_link_clicks", ["dispatch_link_id"], :name => "index_dispatch_link_clicks_on_dispatch_link_id"

    create_table "dispatch_links" do |t|
      t.integer  "dispatch_id"
      t.string   "uri"
      t.integer  "position"
      t.integer  "clicks_count", :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "dispatch_links", ["clicks_count"], :name => "index_dispatch_links_on_clicks_count"
    add_index "dispatch_links", ["dispatch_id"], :name => "index_dispatch_links_on_dispatch_id"

    create_table "dispatch_opens" do |t|
      t.integer  "dispatch_id"
      t.string   "email"
      t.string   "ip"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "dispatch_opens", ["created_at"], :name => "index_dispatch_opens_on_created_at"
    add_index "dispatch_opens", ["dispatch_id"], :name => "index_dispatch_opens_on_dispatch_id"

    create_table "dispatch_unsubscribes" do |t|
      t.integer  "dispatch_id"
      t.string   "email"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "dispatch_unsubscribes", ["dispatch_id"], :name => "index_dispatch_unsubscribes_on_dispatch_id"

    create_table "dispatches" do |t|
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

    create_table "queued_dispatches" do |t|
      t.integer  "dispatch_id"
      t.integer  "emailable_id"
      t.string   "emailable_type"
      t.datetime "sent_at"
      t.integer  "failed_attempts",     :default => 0
      t.datetime "opened_at"
      t.datetime "last_failed_attempt"
      t.text     "last_error"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "queued_dispatches", ["dispatch_id"], :name => "index_queued_dispatches_on_dispatch_id"
    add_index "queued_dispatches", ["emailable_id"], :name => "index_queued_dispatches_on_emailable_id"
  end

  def down
    drop_table :dispatch_bounces
    drop_table :dispatch_link_clicks
    drop_table :dispatch_links
    drop_table :dispatch_opens
    drop_table :dispatch_unsubscribes
    drop_table :dispatches
    drop_table :queued_dispatches
  end
end
