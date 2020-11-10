class PostsController < ApplicationController
  def new
  end

  def create
    if current_user.nil?
      redirect_to '/login'
      return
    end
    @post = Post.preload(:topic).new(params.require(:post).permit(:title, :text))
    @post.user_id = current_user.id
    @post.topic_id = params.require(:topic).require(:id)
    @post.save
    redirect_to @post.topic
  end

  def show
    @post = Post.find(params[:id])
    @words = JSON.load(@post.text)
  end

  def destroy
    @post = Post.preload(:topic).find(params[:id])
    if @post.user_id != current_user.id
      flash[:notice] = "This isn't your post!"
      redirect_to @post.topic
    else
      @post.delete
      flash[:notice] = "Deleted!"
      redirect_to @post.topic
    end
  end
end
