class AddWonAtToDeals < ActiveRecord::Migration[8.0]
  def change
    add_column :deals, :won_at, :datetime
  end
end
