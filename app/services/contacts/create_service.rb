module Contacts
  class CreateService
    def initialize(user, company, params)
      @user = user
      @company = company
      @params = params
    end

    def call
      contact = @company.contacts.build(@params)

      if contact.save
        contact.create_activity(
          key: 'contact.created',
          owner: @user,
          recipient: @company
        )
      end

      contact
    end
  end
end
