class RemoveBlahFromTopic < ActiveRecord::Migration[6.0]
  def change
    remove_column :topics, :blah, :string
  end
end
