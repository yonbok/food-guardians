class AddGenreToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :genre_id, :integer, null: false
  end
end
