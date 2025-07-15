class AddEnteredStageAtToDeals < ActiveRecord::Migration[8.0]
  def change
    add_column :deals, :entered_stage_at, :datetime
  end
end
