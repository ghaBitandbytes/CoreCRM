class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.date :due_date
      t.string :status
      t.references :taskable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
