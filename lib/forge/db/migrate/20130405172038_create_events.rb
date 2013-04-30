class CreateEvents < ActiveRecord::Migration
  def up
    create_table "events" do |t|
        t.string   "title"
        t.string   "location"
        t.text     "description"
        t.datetime "starts_at"
        t.datetime "ends_at"
        t.boolean  "published",   :default => false
        t.datetime "created_at"
        t.datetime "updated_at"
      end
  end

  def down
    drop_table :events
  end
end