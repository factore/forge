class CreateSettings < ActiveRecord::Migration
  def up
    create_table "settings" do |t|
      t.string   "var",                      :null => false
      t.text     "value"
      t.integer  "thing_id"
      t.string   "thing_type", :limit => 30
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true
  end

  def down
    drop_table :settings
  end
end
