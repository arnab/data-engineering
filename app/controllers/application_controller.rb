class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def signed_in_user
    redirect_to signin_path, notice: "Please sign in or sign up to continue." unless signed_in?
  end
end
