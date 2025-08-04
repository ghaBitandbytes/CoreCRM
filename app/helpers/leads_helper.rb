module LeadsHelper
  def lead_status_badge(lead)
    status_class = "status-#{lead.status.parameterize}"
    status_label = lead.status.titleize
    content_tag(:span, status_label, class: "badge #{status_class}")
  end

  def filter_button(name, status_value)
  is_active = (params[:status].to_s == status_value.to_s || (status_value == 'all' && params[:status].blank?))
  link_to name,
          leads_path(status: (status_value unless status_value == 'all')),
          class: "btn btn-sm #{is_active ? 'btn-primary' : 'btn-outline-primary'}"
end


end

