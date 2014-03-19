class AddTurnsToGames < ActiveRecord::Migration
  def change
    add_column :games, :turns, :integer, :limit => 1, :after => :status, :default => 0
  end
end
