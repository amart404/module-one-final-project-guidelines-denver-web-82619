class CreateTeamsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.references :user, foreign_key: true
      t.references :player, foreign_key: true
    end 
  end
end
