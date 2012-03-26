class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome #{@user.name}! You have successfully signed up."
      redirect_to :root
    else
      render 'new'
    end
  end
end
