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
end
