module Stages
  class CreateService
    def initialize(params)
      @params = params
    end

    def call
      Stage.create(@params)
    end
  end
end
