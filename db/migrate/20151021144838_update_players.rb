class UpdatePlayers < ActiveRecord::Migration
  def change
    remove_column :players, :provider_id
    remove_column :players, :provider
    remove_column :players, :email
    remove_column :players, :score
    add_column :players, :score, :integer, null: false, default: 0
  end
end
