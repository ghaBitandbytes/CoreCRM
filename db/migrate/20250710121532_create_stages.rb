class CreateStages < ActiveRecord::Migration[8.0]
  def change
    create_table :stages do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
