class DropColumnFromSongs < ActiveRecord::Migration
  def change
    remove_column :songs, :playlist_id, :integer
  end
end
