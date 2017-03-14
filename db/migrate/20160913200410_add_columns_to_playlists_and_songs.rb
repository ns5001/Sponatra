class AddColumnsToPlaylistsAndSongs < ActiveRecord::Migration
  def change
    add_column :playlists, :user_id, :integer
    add_column :songs, :playlist_id, :integer
  end
end
