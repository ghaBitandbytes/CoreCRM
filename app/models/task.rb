# app/models/task.rb
class Task < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller&.current_user }


  belongs_to :taskable, polymorphic: true
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  enum :status, { pending: 0, done: 1 }

  validates :title, :due_date, :status, presence: true
end
