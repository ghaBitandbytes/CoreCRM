class ContactsController < ApplicationController
  before_action :set_company, only: [:index, :new, :create], if: -> { params[:company_id].present? }
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def index
    @contacts = @company ? @company.contacts : Contact.all
  end

  def show; end

  def new
    @contact = @company.contacts.build
  end

  def create
  @contact = @company.contacts.build(contact_params)
  if @contact.save
    @contact.create_activity key: 'contact.created', 
                            owner: current_user, 
                            recipient: @company
    redirect_to company_contacts_path(@company), notice: "Contact created successfully."
  else
    render :new
  end
end

  def edit; end

  def update
    if @contact.update(contact_params)
      redirect_to contact_path(@contact), notice: "Contact updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to companies_path, notice: "Contact deleted."
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :title)
  end
end
