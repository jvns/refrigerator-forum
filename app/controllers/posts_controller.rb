class PostsController < ApplicationController
  def new
  end

  def create
    if current_user.nil?
      redirect_to '/login'
    end
    @post = Post.new(params.require(:post).permit(:title, :text))

    @post.save
    redirect_to @post
  end

  def show
    @post = Post.find(params[:id])
  end
end
