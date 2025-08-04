module Deals
  class CreateService
    def initialize(company, user, params)
      @company = company
      @user = user
      @params = params
    end

    def call
      deal = @company.deals.build(deal_attributes)
      deal.user = @user
      deal.entered_stage_at ||= Time.current

      if deal.save
        deal.create_activity(
          key: 'deal.created',
          owner: @user,
          recipient: @company
        )
      end

      deal
    end

    private

    def deal_attributes
      @params.require(:deal).permit(:title, :value, :probability, :close_date, :stage_id, :contact_id)
    end
  end
end
