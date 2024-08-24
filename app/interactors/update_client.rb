class UpdateClient
  include Interactor

  def call
    update_client_attributes
    handle_client_status_change if context.client.errors.empty?
  end

  private

  def update_client_attributes
    unless context.client.update(context.client_params)
      context.fail!(error: context.client.errors.full_messages.join(', '))
    end
  end

  def handle_client_status_change
    toggle_client_status
    update_client_name
  end

  def toggle_client_status
    if context.client.enabled?
      context.server_service.enable_client(context.client.uuid)
    else
      context.server_service.disable_client(context.client.uuid)
    end
  end

  def update_client_name
    context.server_service.update_name(context.client.uuid, context.client.name)
  end
end
