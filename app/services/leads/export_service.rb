require 'csv'

class Leads::ExportService
  def self.to_csv(leads)
    CSV.generate(headers: true) do |csv|
      csv << %w[Name Email Status Source]

      leads.each do |lead|
        csv << [lead.name, lead.email, lead.status, lead.source]
      end
    end
  end
end
