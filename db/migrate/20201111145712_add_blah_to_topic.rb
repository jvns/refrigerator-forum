class AddBlahToTopic < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :blah, :string
  end
end
