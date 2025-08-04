module Companies
  class ActivityFetcher
    def initialize(company)
      @company = company
    end

    def call
      return [] unless @company.present?

      PublicActivity::Activity.where(
        "(trackable_type = 'Company' AND trackable_id = :company_id) OR " +
        "(trackable_type = 'Contact' AND recipient_id = :company_id AND recipient_type = 'Company') OR " +
        "(trackable_type = 'Deal' AND recipient_id = :company_id AND recipient_type = 'Company') OR " +
        "(trackable_type = 'Task' AND trackable_id IN (:task_ids))",
        company_id: @company.id,
        task_ids: @company.tasks.pluck(:id)
      ).order(created_at: :desc).limit(10)
    end
  end
end
