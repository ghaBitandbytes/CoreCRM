# app/models/concerns/roleable.rb
module Roleable
  extend ActiveSupport::Concern

  included do
    ROLES = %w[admin sales viewer salesmanager].freeze
    ROLES.each do |r|
      define_method("#{r}?") { role == r }
    end
  end
end
