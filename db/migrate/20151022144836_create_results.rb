class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :player_id, null: false
      t.string :state, null: false
      t.decimal :seconds, precision: 12, scale: 2, null: false, default: 0
      t.decimal :start, precision: 12, scale: 2, null: false
      t.integer :score, null: false
      t.timestamps
    end

    # add_index :results, [:state, :n, :seconds]
    # add_index :results, :player_id

    create_table :questions_results, id: false do |t|
      t.integer :question_id, null: false
      t.integer :result_id, null: false
    end
    add_index :questions_results, [:question_id, :result_id], unique: true
  end
end