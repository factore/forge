class CreatePostCategories < ActiveRecord::Migration
  def up
    create_table "post_categories" do |t|
      t.string   "title"
      t.integer  "list_order", :default => 999
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "post_categories_posts", :id => false do |t|
      t.integer "post_category_id"
      t.integer "post_id"
    end
  end

  def down
    drop_table :post_categories
    drop_table :post_categories_posts
  end
end