class CreateSubscribers < ActiveRecord::Migration
  def up
    create_table "subscriber_group_members" do |t|
      t.integer  "subscriber_id"
      t.integer  "group_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "subscriber_group_members", ["group_id"], :name => "index_subscriber_group_members_on_group_id"
    add_index "subscriber_group_members", ["subscriber_id"], :name => "index_subscriber_group_members_on_subscriber_id"

    create_table "subscriber_groups" do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "subscribers" do |t|
      t.string   "name"
      t.string   "email"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table :subscribers
    drop_table :subscriber_groups
    drop_table :subscriber_group_members
  end
end