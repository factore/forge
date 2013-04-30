class CreateVideos < ActiveRecord::Migration
  def up
    create_table "videos" do |t|
      t.integer  "user_id"
      t.string   "title"
      t.string   "thumbnail_file_name"
      t.string   "thumbnail_content_type"
      t.integer  "thumbnail_file_size"
      t.datetime "thumbnail_updated_at"
      t.string   "video_file_name"
      t.string   "video_content_type"
      t.integer  "video_file_size"
      t.datetime "video_updated_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "encoded_state"
      t.string   "mobile_encoded_state"
      t.string   "output_url"
      t.string   "mobile_output_url"
      t.integer  "job_id"
      t.text     "description"
      t.boolean  "published",              :default => true
      t.boolean  "allow_comments",         :default => true
    end

    add_index "videos", ["job_id"], :name => "index_videos_on_job_id"
    add_index "videos", ["user_id"], :name => "index_videos_on_user_id"
  end

  def down
    drop_table :videos
  end
end