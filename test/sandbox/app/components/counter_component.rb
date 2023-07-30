class CounterComponent < TurboComponent::Component
  attribute :count, :integer, default: 0

  def template
    <<~CONTENT.html_safe
      <div>
          <h2 class="text-2xl font-bold">#{ count }</h2>
          <button data-action="click->turbo-component#handle" data-turbo-component-action-param="increment" class="rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">+ Increment</button>
          <button data-action="click->turbo-component#handle" data-turbo-component-action-param="decrement" class="rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">- Decrement</button>

          <p>You have this value: <span x-text="$wire.count"></span></p>
      </div>
    CONTENT
  end

  def increment
    self.count += 1
  end

  def decrement
    self.count -= 1
  end
end