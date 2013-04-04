class CreateHelpTopics < ActiveRecord::Migration
  def up
    create_table "help_topics" do |t|
      t.string   "language",   :default => "en", :null => false
      t.string   "slug",                         :null => false
      t.string   "title",                        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "content"
    end

    add_index "help_topics", ["title"], :name => "index_help_topics_on_title"
  end

  def down
    drop_table :help_topics
  end
end