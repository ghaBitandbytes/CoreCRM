class AddReminderDateToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :reminder_date, :date
  end
end
