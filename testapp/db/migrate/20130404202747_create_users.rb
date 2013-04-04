class CreateUsers < ActiveRecord::Migration
  def up
    create_table "users" do |t|
      t.string   "email",                                 :default => "",    :null => false
      t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                         :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "avatar_file_name"
      t.string   "avatar_content_type"
      t.integer  "avatar_file_size"
      t.boolean  "approved",                              :default => false
      t.datetime "reset_password_sent_at"
    end

    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end

  def down
    drop_table :users
  end
end
