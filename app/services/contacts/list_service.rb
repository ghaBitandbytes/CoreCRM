module Contacts
  class ListService
    def initialize(user, company = nil)
      @user = user
      @company = company
    end

    def call
      if @company
        @company.contacts
      else
        ContactPolicy::Scope.new(@user, Contact).resolve
      end
    end
  end
end
