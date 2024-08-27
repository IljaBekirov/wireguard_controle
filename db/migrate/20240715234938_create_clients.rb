# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.text :description
      t.string :uuid, null: false
      t.boolean :enabled
      t.string :address
      t.boolean :downloadable_config
      t.string :transfer_rx
      t.string :transfer_tx
      t.string :latest_handshake_at
      t.datetime :expires_at

      t.timestamps
    end
  end
end
