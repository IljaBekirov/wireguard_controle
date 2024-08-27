# frozen_string_literal: true

class CreateClient
  include Interactor

  def call
    server_service = context.server_service
    client_params = context.client_params

    name = client_params[:category] + client_params[:name]
    server_service.create_client(name)
    client_web = server_service.get_clients.find { |client| client['name'] == name }

    client = Client.new(uuid: client_web['id'])
    client.assign_attributes(
      name: name,
      address: client_web['address'],
      enabled: client_web['enabled'],
      downloadable_config: client_web['downloadableConfig'],
      description: client_params[:description],
      expires_at: client_params[:expires_at]
    )

    if client.save
      context.client = client
    else
      context.fail!(error: client.errors.full_messages.join(', '))
    end
  end
end
