class AddCompanyNotesAssignedToToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :company, :string
    add_column :leads, :notes, :text
    add_column :leads, :assigned_to, :string
  end
end
