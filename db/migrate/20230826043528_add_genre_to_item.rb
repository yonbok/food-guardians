class AddGenreToItem < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :genre, :integer
  end
end
