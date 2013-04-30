class CreateCountries < ActiveRecord::Migration
  def up
    create_table "countries" do |t|
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
  end

  def down
    drop_table :countries
  end
end