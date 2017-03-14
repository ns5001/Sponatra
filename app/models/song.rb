class Song < ActiveRecord::Base
  has_many :song_playlists
  has_many :playlists, :through => :song_playlists
  has_many :users, :through => :playlists

  def recommendations
    @matched_playlists = self.playlists
    @matched_songs = []

    @matched_playlists.each do |playlist|
      playlist.songs.each do |song|
        @matched_songs << song
      end
    end
    @matched_songs = @matched_songs.uniq
  end

end
