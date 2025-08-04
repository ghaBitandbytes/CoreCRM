# app/models/comment.rb
class Comment < ApplicationRecord
  include PublicActivity::Model
  include ActionView::RecordIdentifier

  tracked owner: ->(controller, model) { controller&.current_user }

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  after_create_commit :broadcast_create
  after_destroy_commit :broadcast_destroy

  after_create :notify_mentioned_users

  def mentioned_users
    body.scan(/@(\w+)/).flatten.map do |username|
      User.find_by(username: username)
    end.compact.uniq
  end

  private

  def broadcast_create
    broadcast_append_to [commentable, :comments],
                        target: "#{dom_id(commentable)}_comments",
                        partial: "comments/comment",
                        locals: { comment: self, local_user: nil }
  end

  def broadcast_destroy
    broadcast_remove_to [commentable, :comments],
                         target: dom_id(self)
  end

  def notify_mentioned_users
    MentionNotifierService.new(self).call
  end
end
