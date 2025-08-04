module Stages
  class UpdateService
    def initialize(stage, params)
      @stage = stage
      @params = params
    end

    def call
      @stage.update(@params)
    end
  end
end
