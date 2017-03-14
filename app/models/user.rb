class User < ActiveRecord::Base
  has_secure_password
  has_many :playlists, dependent: :destroy
  has_many :songs, :through => :playlists

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def self.valid_email?(email)
    email.match(VALID_EMAIL_REGEX) && User.find_by(email: email).nil?
  end

end
