class CreateProvinces < ActiveRecord::Migration
  def up
    create_table "provinces" do |t|
      t.string   "title"
      t.string   "code"
      t.integer  "country_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "provinces", ["code"], :name => "index_provinces_on_code"
    add_index "provinces", ["country_id"], :name => "index_provinces_on_country_id"
    add_index "provinces", ["title"], :name => "index_provinces_on_title"
  end

  def down
    drop_table :provinces
  end
end