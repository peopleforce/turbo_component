# frozen_string_literal: true

module TurboComponent
  class Component
    include ActiveModel::Model
    include ActiveModel::Attributes

    require 'erb'

    attribute :id, :string
    attribute :params, array: true, default: []
    attribute :streams, array: true, default: []

    def initialize(params = {})
      super

      params.each do |key, value|
        setter = "#{key}="
        send(setter, value) if respond_to?(setter.to_sym, false)
      end
    end

    def data
      d = {}
      self.class.new.attributes.except("id").each do |key, value|
        d[key] = send(key)
      end
      d
    end

    def render_in(view_context)
      before_render if defined?(before_render)

      id = SecureRandom.uuid
      snapshot = {
        data: data,
        memo: {
          id: id,
          name: self.class.name,
          children: [],
          "lazyLoaded": false,
          errors: []
        }
      }.to_json

      # render erb file to string
      rendered_template = if defined?(template)
                            template
                          else
                            file_path, line_number = get_relative_path_to_class(self.class)
                            template = File.read(file_path.gsub(".rb", "") + ".html.erb")
                            ERB.new(template).result(binding)
                          end

      <<~CONTENT.html_safe
        <div id="turbo-component-#{id}" 
        data-controller="turbo-component" 
        data-turbo-component-snapshot-value="#{ CGI::escapeHTML(snapshot)}" 
        data-turbo-component-component-id-value="#{id}"
        data-turbo-component-component-name-value="#{self.class.name}">
                #{rendered_template}
        </div>
      CONTENT
    end

    def get_relative_path_to_class(klass)
      full_path, _ = klass.instance_method(:noop).source_location
      relative_path = Pathname.new(full_path).relative_path_from(Rails.root)
      relative_path.to_s
    end

  end
end
