class AddLastColorToGames < ActiveRecord::Migration
  def change
    add_column :games, :last_color, :boolean, :after => :last_id, :null => false, :default => false
  end
end
