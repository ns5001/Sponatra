require 'rack-flash'

class ApplicationController < Sinatra::Base

  use Rack::Flash

  register Sinatra::ActiveRecordExtension

  enable :sessions
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/' do
    erb :index
  end

  helpers do

    def current_user
      @user ||= User.find_by_id(session[:id])
    end

  end
end
