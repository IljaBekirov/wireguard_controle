# lib/tasks/fetch_data.rake

require 'httparty'
require_relative '../api_client'

namespace :data do
  desc "Fetch data from URL and save it to the database"
  task fetch: :environment do
    include ApplicationHelper

    url = 'http://77.91.78.68:51821/api'
    password = 'fdIrGa3uuPO2'
    api_client = ApiClient.new(url, password)

    # Выполните логин
    api_client.login

    # Получите данные о клиентах
    response = api_client.get_clients

    if response.success?
      data = response.parsed_response

      data.each do |item|
        client = Client.find_or_initialize_by(uuid: item['id'])
        client.assign_attributes(
          name: item['name'],
          address: item['address'],
          enabled: item['enabled'],
          downloadable_config: item['downloadableConfig'],
          transfer_rx: human_readable_size(item['transferRx']),
          transfer_tx: human_readable_size(item['transferTx'])
        )
        client.save!
      end

      puts "Data has been successfully fetched and saved."
    else
      puts "Failed to fetch data. Response code: #{response.code}"
    end
  end
end
