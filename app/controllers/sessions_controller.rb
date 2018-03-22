class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    puts "login"
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      # flash[:success] = "You have successfully logged in"
      redirect_to mailer_path
    else
      flash.now[:danger] = "Invalid credentials"
      redirect_to root_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end