class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :last_id
      t.string :grid
      t.string :state
      t.integer :status
      t.timestamps
    end
  end
end
