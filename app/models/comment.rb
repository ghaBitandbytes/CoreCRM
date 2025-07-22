# app/models/comment.rb
class Comment < ApplicationRecord
  include PublicActivity::Model
  include ActionView::RecordIdentifier

  tracked owner: ->(controller, model) { controller&.current_user }

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  # Turbo broadcast on creation
  after_create_commit -> {
    broadcast_append_to [commentable, :comments],
                        target: "#{dom_id(commentable)}_comments",
                        partial: "comments/comment",
                        locals: { comment: self, local_user: nil }
  }

  # Turbo broadcast on deletion
  after_destroy_commit -> {
    broadcast_remove_to [commentable, :comments],
                         target: dom_id(self)
  }

 after_create :notify_mentioned_users

def mentioned_users
  body.scan(/@(\w+)/).flatten.map do |username|
    User.find_by(username: username)
  end.compact.uniq
end

def notify_mentioned_users
  mentioned_users.each do |user|
    Notification.create!(
      recipient: user,
      actor: self.user,
      notifiable: self,
      action: "mentioned you in a comment",
      read: false
    )
  end
end
end
