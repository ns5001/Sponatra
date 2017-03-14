class PlaylistController < ApplicationController

    get '/playlists/new' do
      erb :'/playlists/new_playlist'
    end

    post '/playlists' do
      @user = current_user

      if params[:playlist][:name] == nil || params[:playlist][:name] == ""
        flash[:message] = "Please fill out the name field."
        erb :'/playlists/new_playlist'
      elsif @user.playlists.include?(Playlist.find_by(name: params[:playlist][:name]))
        flash[:message] = "You already have a playlist with this name."
        erb :'/playlists/new_playlist'
      else
        @playlist = Playlist.create(name: params[:playlist][:name])
        params[:playlist][:songs].each do |song|
          if song != ""
            if RSpotify::Track.search(song).first != nil
              new_song = RSpotify::Track.search(song).first
              spotify = new_song.external_urls["spotify"]
              @song = Song.find_or_create_by(name: new_song.name, spotify: spotify)
              @playlist.songs << @song
              @user.playlists << @playlist
            else
              flash[:message] = "Please enter a valid song."
              erb :'/playlists/new_playlist'
            end
          end
        end
      end
      erb :'/users/home'
    end

    get '/playlists/:id' do
      @playlist = Playlist.find_by(id: params[:id])
      erb :'/playlists/show'
      # binding.pry
    end

    get '/playlist/:id/edit' do
      @playlist = Playlist.find_by(id: params[:id])
      # binding.pry
      erb :'/playlists/edit'
    end

    get '/playlist/:id/:song_id/songdelete' do
      @playlist = Playlist.find_by(id: params[:id])
      @playlist.songs.delete(Song.find_by(id: params[:song_id]))
      redirect to "/playlist/#{@playlist.id}/edit"
    end

    get '/playlist/:id/songadd' do
      @playlist = Playlist.find_by(id: params[:id])
      erb :'/playlists/add'
    end

    post '/playlist/:id/add' do
      @playlist = Playlist.find_by(id: params[:id])
      params[:playlist][:songs].each do |song|
        if song != ""
          if RSpotify::Track.search(song).first != nil
            new_song = RSpotify::Track.search(song).first
            spotify = new_song.external_urls["spotify"]
            check = Song.find_or_create_by(name: new_song.name, spotify: spotify)
            if @playlist.songs.find_by(name: check.name) != nil
              check.destroy
            else
              @playlist.songs << check
            end
          end
        end
      end
      redirect to "/playlists/#{@playlist.id}"
    end

    get '/playlist/:id/delete' do
      @user = current_user
      @playlist = Playlist.find_by(id: params[:id])
      @playlist.destroy
      flash[:message] = "We hope you don't miss your playlist too much."
      erb :'/users/home'
    end

    get '/playlists/:song_id/:id/search' do
      @song = Song.find_by(id: params[:song_id])
      @playlist = Playlist.find_by(id: params[:id])
      @array = @song.recommendations
      @array = @array.select {|song| !@playlist.songs.include?(song)}
      erb :'/playlists/search'
    end

    post '/found/:id' do
      @playlist = Playlist.find_by(id: params[:id])
      params[:song].each do |song|
        @playlist.songs << Song.find_by(name: song)
      end
      flash[:message] = "We hope you like your new songs!"
      erb :'/playlists/show'
    end
end
