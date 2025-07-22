class AnalyticsController < ApplicationController
  before_action :authenticate_user!

 def lead_conversion
  
  @monthly_leads_created = Lead.group_by_month(:created_at, format: "%b %Y", time_zone: "Asia/Karachi").count.presence || {}
  @monthly_leads_converted = Lead.where.not(converted_at: nil).group_by_month(:converted_at, format: "%b %Y", time_zone: "Asia/Karachi").count.presence || {}

  @conversion_funnel = {
    "Leads Created" => Lead.count,
    "Leads Contacted" => Lead.where(status: "Contacted").count,
    "Leads Converted" => Lead.where.not(converted_at: nil).count
  }
end

def analytics

@win_loss_ratio = Deal.joins(:stage)
                      .where(stages: { name: ["Won", "Lost"] })
                      .group("stages.name")
                      .count

  # Get all deals where the associated stage is "Won"
won_deals = Deal.joins(:stage).where(stages: { name: 'Won' }).where.not(won_at: nil)

@avg_deal_cycle_time = if won_deals.any?
  won_deals.map { |d| (d.won_at.to_date - d.created_at.to_date).to_i }.sum / won_deals.size
else
  0
end


  # Only deals that are not yet won or lost
  open_deals = Deal.joins(:stage).where.not(stages: { name: ['Won', 'Lost'] })

  # Group by expected close month and sum their values
  @forecast_revenue = open_deals
    .where.not(close_date: nil)
    .group_by_month(:close_date)
    .sum(:value)


  @leads_by_month = Lead.group_by_month(:created_at).count
  @converted_leads_by_month = Lead.where.not(converted_at: nil).group_by_month(:converted_at).count

  @lead_sources = Lead.group(:source).count
  @deal_distribution_by_industry = Deal.joins(:company).group("companies.industry").count
end

  
end
