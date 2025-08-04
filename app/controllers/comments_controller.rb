class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_comment, only: [:destroy]
  before_action :authorize_user!, only: [:destroy]

  def create
    @comment = Comments::CreateService.new(current_user, @commentable, comment_params).call

    if @comment.persisted?
      redirect_back fallback_location: root_path, notice: "Comment added."
    else
      redirect_back fallback_location: root_path, alert: "Failed to add comment."
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "Comment removed." }
      format.turbo_stream
    end
  end

  private

  def set_commentable
    klass = [Task].find { |c| params["#{c.name.underscore}_id"].present? }
    if klass
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    else
      redirect_to root_path, alert: "Invalid comment association"
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Comment not found"
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user!
    unless @comment.user == current_user || current_user.admin?
      redirect_back fallback_location: root_path, alert: "You are not authorized to perform this action."
    end
  end
end
