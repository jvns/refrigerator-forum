class AddUserToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :user_id, :int
    add_foreign_key :posts, :users
  end
end
