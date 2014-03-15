class AddPlayer1IdandPlayer2IdtoGames < ActiveRecord::Migration
  def change
    add_column :games, :player1_id, :integer, :after => :id
    add_column :games, :player2_id, :integer, :after => :player1_id
  end
end
