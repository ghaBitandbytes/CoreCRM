class AddFieldsToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :industry, :string
    add_column :companies, :website, :string
    add_column :companies, :address, :string
    add_column :companies, :phone, :string
  end
end
