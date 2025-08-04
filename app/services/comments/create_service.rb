module Comments
  class CreateService
    def initialize(user, commentable, params)
      @user = user
      @commentable = commentable
      @params = params
    end

    def call
      comment = @commentable.comments.build(@params)
      comment.user = @user
      comment.save
      comment
    end
  end
end
