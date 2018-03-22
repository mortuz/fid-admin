class MailController < ApplicationController
  require 'mailgun'

  before_action :require_user
  
  def new
    
  end
  
  def sendmail
    email = params[:mailer][:email]
    subject = params[:mailer][:subject]
    message = params[:mailer][:message]

    # sender
    sender = "#{current_user.name} <#{current_user.email}>"
    
    # First, instantiate the Mailgun Client with your API key
    mg_client = Mailgun::Client.new 'key-9793adf968a4fb57cc6f619b58b98d4c'
    
    # Define your message parameters
    message_params =  { from: sender,
                        to: email,
                        subject: subject,
                        text: message
                      }
    
    # Send your message through the client
    result = mg_client.send_message('idevia.in', message_params).to_h!
    
    puts result
    
    if result
      flash[:success] = "Email has been sent"
    end
    
    render 'new'

  end
  
end