class PagesController < ApplicationController
  def index
    if logged_in?
      if current_user.admin?
        redirect_to invites_path
      else
        redirect_to mailer_path
      end
    end
  end
end