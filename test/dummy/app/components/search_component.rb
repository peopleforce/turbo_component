class SearchComponent < TurboComponent::Component
  attribute :query, :string

  def search
    @items = items

    if query.present?
      @items = @items.select { |item| item.include?(query) }
    end
  end

  def noop

  end

  def items
    ["apple", "banana", "orange", "pear", "grape", "pineapple", "strawberry"]
  end
end