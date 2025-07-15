class Contact < ApplicationRecord
  include PublicActivity::Model
tracked owner: ->(controller, model) { controller&.current_user }

  belongs_to :company
  has_many :deals, dependent: :destroy
end
