class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now[:alert] = "Username or password is invalid"
      render "new"
    end
  end
  def destroy
    slibreadline.so.7: cannot open shared object file: No such file or directoryession[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
