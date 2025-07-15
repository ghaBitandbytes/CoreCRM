class AddStageToDeals < ActiveRecord::Migration[8.0] # or [8.0] if you're on Rails 8 beta
  def change
    add_reference :deals, :stage, foreign_key: true # don't set `null: false` yet
  end
end
