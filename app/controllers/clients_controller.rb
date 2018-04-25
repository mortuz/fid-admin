class ClientsController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def show
  end
  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      flash[:success] = "#{@client.name} successfully added"     
      redirect_to clients_path
    end
  end

  def index
    @clients = Client.all
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
      if @client.update(client_params)
        flash[:success] = "Client successfully updated"
        redirect_to clients_path
      else
        render "edit"
      end
  end

  def  destroy
    @client = Client.find(params[:id])
    @client.destroy
    flash[:success] = "#{@client.name} is successfully deleted"
    redirect_to clients_path
  end

  def getBulk
  end

  def postBulk
    contacts = JSON.parse params[:bulk][:data]
    
    contacts.each do |contact|
      client = Client.new
      client.name = contact["name"]
      client.email = contact["email"]
      client.group = contact["group"]
      # puts client
      # @invite.name = contact.name
      # @invite.email = contact.email

      if client.save       

      end
    end
    flash[:success] = "Clients successfully added"
    redirect_to clients_path
  end

  private
    def client_params
      params.require(:client).permit(:name, :email, :group)
    end

    def require_admin
      puts logged_in? and !current_user.admin?
      if logged_in? and !current_user.admin?
        flash[:danger] = "Only admin can perform that action"
        redirect_to root_path
      end
    end
end