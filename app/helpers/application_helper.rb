module ApplicationHelper
  def status_color_border(status)
    case status
    when 'New' then 'border-blue-500'
    when 'Contacted' then 'border-yellow-500'
    when 'Qualified' then 'border-purple-500'
    when 'Converted' then 'border-green-500'
    when 'Lost' then 'border-red-500'
    else 'border-gray-300'
    end
  end

  def status_color_bg(status)
    case status
    when 'New' then 'bg-blue-500'
    when 'Contacted' then 'bg-yellow-500'
    when 'Qualified' then 'bg-purple-500'
    when 'Converted' then 'bg-green-500'
    when 'Lost' then 'bg-red-500'
    else 'bg-gray-300'
    end
  end

  def status_icon(status)
    case status
    when 'New' then 'fas fa-star text-blue-500'
    when 'Contacted' then 'fas fa-phone-alt text-yellow-500'
    when 'Qualified' then 'fas fa-badge-check text-purple-500'
    when 'Converted' then 'fas fa-check-circle text-green-500'
    when 'Lost' then 'fas fa-times-circle text-red-500'
    else 'fas fa-circle text-gray-300'
    end
  end

  def lead_status_dot(status)
    case status
    when 'New' then 'bg-blue-500'
    when 'Contacted' then 'bg-yellow-500'
    when 'Qualified' then 'bg-purple-500'
    when 'Converted' then 'bg-green-500'
    when 'Lost' then 'bg-red-500'
    else 'bg-gray-300'
    end
  end

  def activity_color(activity)
    case activity.trackable_type
    when 'Contact' then 'teal'
    when 'Deal' then 'blue'
    when 'Task' then 'amber'
    when 'Company' then 'green'
    else 'purple'
    end
  end

  def activity_icon(activity)
    case activity.trackable_type
    when 'Contact' then 'fas fa-user'
    when 'Deal' then 'fas fa-handshake'
    when 'Task' then 'fas fa-tasks'
    when 'Company' then 'fas fa-building'
    else 'fas fa-info-circle'
    end
  end

 def activity_description(activity)
  role = activity.owner&.role || "system"

  case activity.key
  when 'contact.create', 'contact.created'
    "#{role} created contact #{activity.trackable&.name || 'a contact'}"
  when 'contact.update', 'contact.updated'
    "#{role} updated contact #{activity.trackable&.name || 'a contact'}"
  when 'deal.create', 'deal.created'
    "#{role} created deal #{activity.trackable&.title || 'a deal'}"
  when 'deal.update', 'deal.updated'
    "#{role} updated deal #{activity.trackable&.title || 'a deal'}"
  when 'task.create', 'task.created'
    "#{role} created task #{activity.trackable&.title || 'a task'}"
  when 'task.update', 'task.updated'
    "#{role} updated task #{activity.trackable&.title || 'a task'}"
  when 'company.create', 'company.created'
    "#{role} created a company"
  when 'company.update', 'company.updated'
    "#{role} updated company details"
  else
    "#{role} performed #{activity.key.humanize.downcase}"
  end
end


end