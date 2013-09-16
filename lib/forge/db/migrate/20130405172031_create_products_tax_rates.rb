class CreateProductsTaxRates < ActiveRecord::Migration
  def up
    create_table "products_tax_rates", :id => false, :force => true do |t|
      t.integer "product_id"
      t.integer "tax_rate_id"
    end

    add_index "products_tax_rates", ["product_id"], :name => "index_products_tax_rates_on_product_id"
    add_index "products_tax_rates", ["tax_rate_id"], :name => "index_products_tax_rates_on_tax_rate_id"
  end

  def down
    drop_table "products_tax_rates"
  end
end
