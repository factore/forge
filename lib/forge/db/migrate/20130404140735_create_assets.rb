class CreateAssets < ActiveRecord::Migration
  def up
    create_table "assets" do |t|
      t.string   "title"
      t.string   "attachment_file_name"
      t.string   "attachment_content_type"
      t.integer  "attachment_file_size"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "encoded_state"
      t.string   "output_url"
      t.string   "aspect_ratio"
      t.integer  "duration_in_ms"
      t.integer  "job_id"
    end

    add_index "assets", ["created_at"], :name => "index_assets_on_created_at"
    add_index "assets", ["job_id"], :name => "index_assets_on_job_id"
  end

  def down
    drop_table "assets"
  end
end
