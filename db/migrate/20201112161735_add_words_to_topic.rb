class AddWordsToTopic < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :words, :text
  end
end
