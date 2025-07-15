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

  # Notify mentioned users
  after_create :notify_mentioned_users

  # Extracts mentioned usernames (e.g. @john)
  def mentioned_usernames
    body.scan(/@(\w+)/).flatten
  end

  private

  def notify_mentioned_users
    mentioned_usernames.each do |username|
      mentioned_user = User.find_by(username: username)
      next unless mentioned_user && mentioned_user != user

      Notification.create!(
        user: mentioned_user,
        actor: user,
        action: "mentioned you in a comment",
        notifiable: self
      )
    end
  end
end
