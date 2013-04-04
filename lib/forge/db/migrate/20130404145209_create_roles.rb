class CreateRoles < ActiveRecord::Migration
  def up
    create_table "roles" do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles_users", :id => false do |t|
      t.integer "user_id"
      t.integer "role_id"
    end

    add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
    add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  end

  def down
    drop_table :roles
  end
end
