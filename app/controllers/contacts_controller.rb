class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:index, :new, :create], if: -> { params[:company_id].present? }
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def index
    authorize Contact
    @contacts = Contacts::ListService.new(current_user, @company).call
  end

  def show
    authorize @contact
  end

  def new
    @contact = @company.contacts.build
    authorize @contact
  end

  def create
    @contact = Contacts::CreateService.new(current_user, @company, contact_params).call
    authorize @contact

    if @contact.persisted?
      redirect_to company_contacts_path(@company), notice: "Contact created successfully."
    else
      render :new
    end
  end

  def edit
    authorize @contact
  end

  def update
    authorize @contact
    if @contact.update(contact_params)
      redirect_to contact_path(@contact), notice: "Contact updated successfully."
    else
      render :edit
    end
  end

  def destroy
    authorize @contact
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
