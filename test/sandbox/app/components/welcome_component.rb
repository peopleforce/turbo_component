class WelcomeComponent < TurboComponent::Component
  attribute :full_name, :string

  def template
    <<~CONTENT.html_safe
      <div class="border border-gray-300 rounded-lg p-8">
        #{full_name}
      </div>
    CONTENT
  end
end