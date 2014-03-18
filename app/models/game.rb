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

  def stateColor
    self.last_color ? 1 : -1
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

  def updateState(x,y)
    #check current color and update game state accordingly
    self.state[:rows][x] += self.last_color ? 1 : -1
    self.state[:columns][y] += self.last_color ? 1 : -1
    #check if move is on a diagonals
    if (x-y).abs == 2 or x*y == 1
      #move is on diagonal 1
      self.state[:diags][2] += self.last_color ? 1 : -1
    end
    if x-y == 0
      #move is diagonal 0
      self.state[:diags][0] += stateColor()
    end
  end

  def checkWin(x,y)
    if self.state[:rows][x].abs == 3 or
        self.state[:columns][y].abs == 3 or
        self.state[:diags][0].abs == 3 or
        self.state[:diags][1].abs == 3
      self.status = TYPES[:ended]
    end
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
    self.updateState(x, y)
    self.checkWin(x,y)
    if self.save
      #send game update
      sendUpdate(:move => move)
      return self
    end
    false
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
