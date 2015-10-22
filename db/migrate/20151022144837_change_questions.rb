class ChangeQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :pictute_1, :picture1
    rename_column :questions, :pictute_2, :picture2
    rename_column :questions, :pictute_3, :picture3
    rename_column :questions, :pictute_4, :picture4
    rename_column :questions, :option_1, :option1
    rename_column :questions, :option_2, :option2
    rename_column :questions, :option_3, :option3
    rename_column :questions, :option_4, :option4
  end
end