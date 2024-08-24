class ClientsController < ApplicationController
  before_action :set_server_service
  before_action :set_client, only: %i[edit show update qr_code configuration]

  def index
    @q = Client.ransack(params[:q])
    @q.sorts = 'id asc' if params[:q].blank?
    @clients = @q.result.page(params[:page]).per(15)
  end

  def edit; end

  def show; end

  def new
    @client = Client.new
  end

  def create
    result = CreateClient.call(server_service: @server_service, client_params: client_params)
    if result.success?
      redirect_to client_path(result.client)
    else
      flash[:error] = result.error
      redirect_to clients_path
    end
  end

  def update
    result = UpdateClient.call(client: @client, server_service: @server_service, client_params: client_params)
    if result.success?
      flash[:success] = 'Клиент обновлен успешно'
      redirect_to clients_path
    else
      flash[:error] = result.error
      redirect_to clients_path
    end
  end

  def refresh
    result = RefreshClients.call(service: @server_service)

    if result.success?
      redirect_to clients_path, notice: 'Клиенты успешно обновлены.'
    else
      flash[:error] = result.error
      redirect_to clients_path
    end
  end

  def qr_code
    svg_content = @server_service.qr_code(@client.uuid)
    render plain: svg_content, content_type: 'image/svg+xml'
  end

  def configuration
    config = @server_service.configuration(@client.uuid)
    filename = "#{@client.name.parameterize}.conf"

    send_data config, filename: filename, type: 'text/plain'
  end

  def check_expired_clients
    clients = Client.check_expired_clients
    clients.each { |client| @server_service.disable_client(client.uuid) }
    redirect_to clients_path, notice: 'Клиенты с истекшим сроком действия были отключены.'
  end

  private

  def client_params
    params.require(:client).permit(:name, :uuid, :enabled, :expires_at, :description)
  end

  def set_server_service
    @server_service = WireguardService
                        .new(ENV['SERVICE_URL'], ENV['SERVICE_PASSWORD'])

    @server_service.login unless @server_service.logged_in?
  end

  def set_client
    @client = Client.find(params[:id])
  end
end
