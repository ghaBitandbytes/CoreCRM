class AddReminderAtToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :reminder_at, :datetime
  end
end
