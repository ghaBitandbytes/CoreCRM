module Deals
  class StageUpdateService
    def initialize(deal, stage)
      @deal = deal
      @stage = stage
    end

    def call
      @deal.won_at = Time.current if @stage.name == "Won"
      @deal.update(stage_id: @stage.id)
    end
  end
end
