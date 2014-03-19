class User < ActiveRecord::Base
  require 'digest/sha1'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of(:first_name, :last_name)

  has_many :hosted_games, :class_name => 'Game', :foreign_key => :player1_id
  has_many :joined_games, :class_name => 'Game', :foreign_key => :player2_id

  def displayName
    "#{self.first_name.capitalize} #{self.last_name[0].upcase}."
  end

  def fullname
    "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end

  def token
    Digest::SHA1.hexdigest "#{self.id}"
  end

  def games
    Game.where('player1_id = ? OR player2_id = ?',self.id, self.id)
  end

end
