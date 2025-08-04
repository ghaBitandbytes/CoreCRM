module LeadFilterable
  extend ActiveSupport::Concern

  def filter_leads(leads)
    leads = search_leads(leads) if params[:query].present?
    leads = status_filter(leads) if params[:status].present?
    leads
  end

  private

  def search_leads(leads)
    q = "%#{params[:query]}%"
    leads.where("name ILIKE :q OR source ILIKE :q OR status ILIKE :q", q: q)
  end

  def status_filter(leads)
    filter_key = params[:status].to_s.downcase.strip

    filter_map = {
      'hot' => 'Qualified',
      'new' => 'New'
    }

    return leads.where("LOWER(status) = ?", filter_map[filter_key].downcase) if filter_map.key?(filter_key)
    return leads if filter_key == 'all'

    leads.none
  end
end
