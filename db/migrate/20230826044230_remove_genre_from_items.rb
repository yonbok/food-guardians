class RemoveGenreFromItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :items, :genre, :integer
  end
end
