class CreateReminders < ActiveRecord::Migration[8.0]
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :notes
      t.datetime :remind_at
      t.string :status
      t.references :lead, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
