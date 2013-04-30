class CreateTaxRates < ActiveRecord::Migration
  def up
    create_table "tax_rates" do |t|
      t.string   "title"
      t.float    "rate",        :default => 0.0, :null => false
      t.integer  "country_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "province_id"
    end

    add_index "tax_rates", ["country_id"], :name => "index_tax_rates_on_country_id"
    add_index "tax_rates", ["province_id"], :name => "index_tax_rates_on_province_id"
  end

  def down
    drop_table :tax_rates
  end
end