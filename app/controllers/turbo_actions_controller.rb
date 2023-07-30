class TurboActionsController < ::ActionController::Base
  skip_before_action :verify_authenticity_token

  def index

  end

  def create
    component_instance = params[:component_name].constantize.new

    turbo_streams = []

    component_instance.before_render if defined?(component_instance.before_render)

    params[:snapshot][:data].each do |k, v|
      component_instance.public_send("#{k}=", v)
    end

    # clear streams
    component_instance.streams = []

    if params[:component_action].present?
      action_params = params[:component_action_params] || []
      component_instance.public_send(params[:component_action], *action_params)
    end

    view = ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)

    turbo_streams << turbo_stream.replace("turbo-component-#{params[:component_id]}", component_instance.render_in(view))
    turbo_streams += component_instance.streams

    render turbo_stream: turbo_streams
  end
end
