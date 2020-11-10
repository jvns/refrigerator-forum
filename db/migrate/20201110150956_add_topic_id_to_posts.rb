class AddTopicIdToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :topic_id, :int, null: false
    add_foreign_key :posts, :topics
  end
end
