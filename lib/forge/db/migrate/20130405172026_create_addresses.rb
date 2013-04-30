class CreateAddresses < ActiveRecord::Migration
  def up
    create_table "addresses" do |t|
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
  end

  def down
    drop_table :addresses
  end
end