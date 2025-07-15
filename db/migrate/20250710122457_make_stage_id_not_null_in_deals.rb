class MakeStageIdNotNullInDeals < ActiveRecord::Migration[8.0] # or [8.0] if you're using beta
  def change
    change_column_null :deals, :stage_id, false
  end
end
