class Game < ActiveRecord::Base
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
  has_many :game_players
  has_many :users, :through => :game_players

  def join(user)
    self.users << user
    self.status = TYPES[:active]
    self.save
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


  def move(user, move)
    x = Integer(move[:x])
    y = Integer(move[:y])
    self.toggleColor
    self.grid[x][y] = self.binColor
    if self.last_color
      self.state[:rows][x] += 1
      self.state[:columns][y] += 1
    else
      self.state[:rows][x] -= 1
      self.state[:columns][y] -= 1
    end

    self.save
  end
end
