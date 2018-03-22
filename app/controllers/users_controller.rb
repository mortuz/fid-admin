class UsersController < ApplicationController
  # before_action :require_admin
  skip_before_action :verify_authenticity_token, only: [:postRecover]
  def new
    token = params[:t]
    @invite = Invite.find_by invite_token: token
    if @invite
      @user = User.new
    else
      puts "no User found"
      render "dash"
    end
  end

  def show
  end

  def edit
  end

  def getReset
    token = params[:t]
    @user = User.find_by recovery_token: token

    puts @user

    if !@user
      render "dash"
      # redirect_to recover_path
    else

    end
  end

  def postReset
    token = params[:user][:token]
    
    @user = User.find_by recovery_token: token
    if @user      
      @user.recovery_token = nil
      if @user.update(user_params)
        flash[:success] = "You have successfully created passsword"
        redirect_to login_path
      else
        flash[:error] = "Something went wrong"
        redirect_to root_path
      end      
    else
      redirect_to root_path
    end
  end

  def getRecover
  end

  def postRecover
    email = params[:recover][:email]
    @user = User.find_by email: email
    hash = SecureRandom.urlsafe_base64.to_s
    if @user
      @user.recovery_token = hash

      if @user.save
        flash[:info] = "Instructions has been to your email"
        send_email
      else
        flash[:danger] = "Error! try again"
      end
    else
      flash[:danger] = "Email is not registered"
    end
    redirect_to root_path
  end
  
  def create    
    token = params[:user][:token]
    
    @invite = Invite.find_by invite_token: token
    if @invite
      @user = User.create(user_params)
      @user.name = @invite.name
      @user.email = @invite.email
      if @user.save
        @invite.invite_token = nil
        @invite.save
        flash[:success] = "You have successfully created passsword"
      else
        flash[:error] = "Something went wrong"
      end
      
      redirect_to root_path
    else
      redirect_to root_path
    end

  end
  
  private
    def user_params
      params.require(:user).permit(:password)
    end

    def send_email
      host = Rails.env.development? ? "http://localhost" : "https://awesome-fidiyo.herokuapp.com"
      # setup recipient
      email = params[:recover][:email]
      name = @user.name
      token = @user.recovery_token
      message = "<html><body><p>Hello #{name}, Click <a href='#{host}/reset?t=#{token}'>#{host}/reset?t=#{token}</a> to reset your password.</p></body></html>"
      puts message
      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new 'key-9793adf968a4fb57cc6f619b58b98d4c'
    
      mb_obj = Mailgun::MessageBuilder.new

      # Define the from address.
      mb_obj.from("email@domain.com", {"first"=>"Team", "last" => "iDevia"})

      # Define a to recipient.
      mb_obj.add_recipient(:to, email, {"first" => name, "last" => ""})
      mb_obj.subject("Recover password!")
      # Define the HTML text of the message
      mb_obj.body_html(message)
      # Send your message through the client
      result = mg_client.send_message('idevia.in', mb_obj).to_h!
            
      puts result
    end

    def require_admin
      if logged_in? && !current_user.admin?
        flash[:danger] = "Only admin can perform that action"
        redirect_to root_path
      end
    end
end