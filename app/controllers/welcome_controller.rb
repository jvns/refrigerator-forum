class WelcomeController < ApplicationController
  def index
    @posts = Post.all
    id = session[:user_id]
    if id
      @user = User.find(id)
    end
  end
end
