class Game < ActiveRecord::Base
  require 'digest/sha1'
  TYPES = {
      :open => 0,
      :active => 1,
      :draw => 2,
      :ended => 3
  }

  scope :open, -> { where(:status => TYPES[:open]) }
  scope :active, -> { where(:status => TYPES[:active]) }
  scope :recent, -> { where('status >= ?', TYPES[:draw]).order(:updated_at).limit(5) }

  serialize :grid
  serialize :state

  belongs_to :player1, :class_name => 'User', :foreign_key => 'player1_id'
  belongs_to :player2, :class_name => 'User', :foreign_key => 'player2_id'

  def displayName
    "#{self.player1.display_name} vs. #{self.player2.display_name}"
  end

  def binColor
    self.last_color ? 1 : 0
  end

  def toggleColor
    self.last_color = !self.last_color
  end

  def userColor(user)
    if self.last_id == user.id
      self.binColor
    else
      self.binColor.zero? ? 1 : 0
    end
  end

  def last_token
    Digest::SHA1.hexdigest "#{self.last_id}"
  end

  def next_token
    #find token for player whose up next
    Digest::SHA1.hexdigest "#{self.player1_id == self.last_id ? self.player2_id : self.player1_id}"
  end

  def player?(player)
    self.player1 == player || self.player2 == player
  end

  def join(user)
    return false if self.status != TYPES[:open]
    self.player2 = user
    self.status = TYPES[:active]
    self.last_id = Random.rand(2).zero? ? self.player1_id : self.player2_id
    if self.save
      sendUpdate(:start => {:displayName => self.displayName, :color => self.userColor(user)})
      return self
    end
    false
  end

  def move(user, move)
    x = Integer(move[:x])
    y = Integer(move[:y])
    #update current color and user id
    self.toggleColor
    self.last_id = user.id
    #update grid
    self.grid[x][y] = self.binColor
    #check current color and update game state accordingly
    if self.last_color
      self.state[:rows][x] += 1
      self.state[:columns][y] += 1
    else
      self.state[:rows][x] -= 1
      self.state[:columns][y] -= 1
    end
    self.save
    #send game update
    sendUpdate(:move => move)
  end

  protected

  def sendUpdate(options = {})
    Pusher['game_updates'].trigger("game_#{self.id}", {
        :game => self.as_json(:only => [
            :grid,
            :status
        ],:methods => [
            :last_token,
            :next_token,
            :binColor
        ])
    }.merge(options))
  end
end
