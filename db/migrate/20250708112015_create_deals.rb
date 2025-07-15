class CreateDeals < ActiveRecord::Migration[8.0]
  def change
    create_table :deals do |t|
      t.string :title
      t.decimal :value
      t.integer :probability
      t.date :close_date
      t.string :stage
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
