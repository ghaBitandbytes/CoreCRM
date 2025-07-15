class Company < ApplicationRecord
  include PublicActivity::Model
tracked owner: ->(controller, model) { controller&.current_user }


  belongs_to :lead
  has_many :deals, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :tasks, as: :taskable, dependent: :destroy

  validates :name, presence: true
end
