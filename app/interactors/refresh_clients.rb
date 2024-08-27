# frozen_string_literal: true

class RefreshClients
  include ApplicationHelper
  include Interactor

  def call
    service = context.service
    clients_data = service.get_clients

    clients_data.each do |item|
      client = Client.find_or_initialize_by(uuid: item['id'])
      client.assign_attributes(
        name: item['name'],
        address: item['address'],
        enabled: item['enabled'],
        downloadable_config: item['downloadableConfig'],
        latest_handshake_at: time_zone(item['latestHandshakeAt']),
        transfer_rx: human_readable_size(item['transferRx']),
        transfer_tx: human_readable_size(item['transferTx'])
      )

      context.fail!(error: client.errors.full_messages.join(', ')) unless client.save
    end
  end
end
