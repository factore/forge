class CreateSales < ActiveRecord::Migration
  def up
    create_table "sales" do |t|
      t.string   "title"
      t.text     "description"
      t.datetime "start"
      t.datetime "end"
      t.float    "value"
      t.string   "sale_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table :sales
  end
end