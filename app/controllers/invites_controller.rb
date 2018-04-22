class InvitesController < ApplicationController
  require 'mailgun'
  before_action :require_admin
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @invites = Invite.all
  end
  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    hash = SecureRandom.urlsafe_base64.to_s
    @invite.invite_token = hash
    sendEmail = params[:send_email]

    if @invite.save
      flash[:success] = "#{@invite.name} successfully added"
      
      # if sendEmail
      send_email
      # end      
      redirect_to invites_path
    else
      render 'new'
    end    
  end

  def edit
    @invite = Invite.find(params[:id])
  end

  def update
    @invite = Invite.find(params[:id])
    sendEmail = params[:send_email]
    puts @invite.invite_token
    if @invite.invite_token
      if @invite.update(invite_params)
        flash[:success] = "User successfully updated"

        if sendEmail
          send_email
        end
        redirect_to invites_path
      else
        render "edit"
      end
    else
      flash[:danger] = "User already joined"
      redirect_to invites_path
    end    
  end

  def  destroy
    @invite = Invite.find(params[:id])
    # puts current_user.id
    if @invite
      @user = User.find_by email: @invite.email
      if @user
        if current_user.id == @user.id
          flash[:danger] = "You can not delete yourself"
          redirect_to invites_path and return
        else
          @user.destroy
        end
      end
      @invite.destroy
      flash[:success] = "#{@invite.name} is successfully deleted"
    end
    redirect_to invites_path
  end

  def getall
    render json: @invites = Invite.all
  end

  def postBulk
    contacts = JSON.parse params[:bulk][:data]
    
    contacts.each do |contact|
      invite = Invite.new
      invite.name = contact["name"]
      invite.email = contact["email"]
      puts invite
      # @invite.name = contact.name
      # @invite.email = contact.email
      hash = SecureRandom.urlsafe_base64.to_s
      invite.invite_token = hash

      if invite.save
        
        # send mail start
        
        host = Rails.env.development? ? "http://localhost:3000" : "https://awesome-fidiyo.herokuapp.com"      
        user_email = invite.email
        name = invite.name
        token = invite.invite_token
        message = "<html><body><p>Hello #{name}! You have been added to an <strong>Awesome App</strong>. Click <a href='#{host}/users/new?t=#{token}'>#{host}/users/new?t=#{token}</a> to access your account.</p></body></html>"
        sender = "#{current_user.name} <#{current_user.email}>"
        puts message
        puts user_email
        # First, instantiate the Mailgun Client with your API key
        mg_client = Mailgun::Client.new 'key-9793adf968a4fb57cc6f619b58b98d4c'
      
        mb_obj = Mailgun::MessageBuilder.new

        # Define the from address.
        mb_obj.from(current_user.email, {"first"=>current_user.name, "last" => ""})

        # Define a to recipient.
        mb_obj.add_recipient(:to, user_email, {"first" => name, "last" => ""})
        mb_obj.subject("An awesome app invite!")
        # Define the HTML text of the message
        mb_obj.body_html(message)
        # Send your message through the client
        result = mg_client.send_message('idevia.in', mb_obj).to_h!
              
        puts result

        # send mail end
      # else
      end
    end
    flash[:success] = "Contacts successfully added"
    redirect_to invites_path
  end

  private
    def invite_params
      params.require(:invite).permit(:name, :email)
    end

    def send_email
      host = Rails.env.development? ? "http://localhost:3000" : "https://awesome-fidiyo.herokuapp.com"      
      email = params[:invite][:email]
      name = params[:invite][:name]
      token = @invite.invite_token
      message = "<html><body><p>Hello #{name}! You have been added to an <strong>Awesome App</strong>. Click <a href='#{host}/users/new?t=#{token}'>#{host}/users/new?t=#{token}</a> to access your account.</p></body></html>"
      sender = "#{current_user.name} <#{current_user.email}>"
      puts message
      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new 'key-9793adf968a4fb57cc6f619b58b98d4c'
    
      mb_obj = Mailgun::MessageBuilder.new

      # Define the from address.
      mb_obj.from(current_user.email, {"first"=>current_user.name, "last" => ""})

      # Define a to recipient.
      mb_obj.add_recipient(:to, email, {"first" => name, "last" => ""})
      mb_obj.subject("An awesome app invite!")
      # Define the HTML text of the message
      mb_obj.body_html(message)
      # Send your message through the client
      result = mg_client.send_message('idevia.in', mb_obj).to_h!
            
      puts result
    end

    def require_admin
      if logged_in? and !current_user.admin?
        flash[:danger] = "Only admin can perform that action"
        redirect_to root_path
      end
    end

end