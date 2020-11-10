class PostsController < ApplicationController
  def new
  end

  def create
    if current_user.nil?
      redirect_to '/login'
      return
    end
    @post = Post.new(params.require(:post).permit(:title, :text))
    @post.user_id = current_user.id
    @post.topic_id = params.require(:topic).require(:id)
    @post.save
    redirect_to @post
  end

  def show
    @post = Post.find(params[:id])
  end
end
