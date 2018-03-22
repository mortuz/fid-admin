class PagesController < ApplicationController
  def index
    redirect_to invites_path if logged_in?
  end
end