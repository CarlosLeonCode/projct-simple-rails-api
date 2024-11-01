class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.datetime :due_date
      t.integer :user_id

      t.timestamps
    end
  end
end
