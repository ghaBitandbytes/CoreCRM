# app/services/mention_notifier_service.rb
class MentionNotifierService
  def initialize(comment)
    @comment = comment
  end

  def call
    mentioned_users.each do |user|
      Notification.create!(
        recipient: user,
        actor: @comment.user,
        notifiable: @comment,
        action: "mentioned you in a comment",
        read: false
      )
    end
  end

  private

  def mentioned_users
    @comment.body.scan(/@(\w+)/).flatten.map do |username|
      User.find_by(username: username)
    end.compact.uniq
  end
end
