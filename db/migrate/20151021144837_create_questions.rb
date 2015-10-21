class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.string :kind, null: false, default: 'simple'
      t.string :picture
      t.string :option_1
      t.string :option_2
      t.string :option_3
      t.string :option_4
      t.string :pictute_1
      t.string :pictute_2
      t.string :pictute_3
      t.string :pictute_4
      t.integer :correct

      t.timestamps
    end
  end
end
