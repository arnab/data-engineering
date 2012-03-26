class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in or sign up to continue."
    end
  end
end
