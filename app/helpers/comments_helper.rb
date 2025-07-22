module CommentsHelper
  def auto_link_mentions(text)
    text.gsub(/@(\w+)/) do |mention|
      if (user = User.find_by(username: $1))
        # Replace with actual route if you have user profiles
        link_to "@#{user.username}", "#", class: "text-blue-600 font-semibold", title: user.email
      else
        mention
      end
    end.html_safe
  end
end
