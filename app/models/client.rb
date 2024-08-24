class Client < ApplicationRecord
  validates :name, :uuid, presence: true, uniqueness: true

  def self.check_expired_clients
    expired_clients = where.not(expires_at: nil).where("expires_at < ?", Time.current)
    expired_clients.update_all(enabled: false)
    expired_clients
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[address created_at description downloadable_config enabled expires_at latest_handshake_at
      name transfer_rx transfer_tx updated_at id]
  end
end
