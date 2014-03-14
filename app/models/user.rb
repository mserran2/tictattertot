class User < ActiveRecord::Base
  require 'digest/sha1'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :game_players
  has_many :games, :through => :game_players

  def display_name
    "#{self.first_name.capitalize} #{self.last_name[0].upcase}."
  end

  def token
    Digest::SHA1.hexdigest "#{self.id}"
  end

end
