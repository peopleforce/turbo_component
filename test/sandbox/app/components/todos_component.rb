class TodosComponent < ActionWire::Component
  attribute :todos, array: true, default: []

  def noop

  end

  def create_todo
    self.todos << "random"
  end

  def destroy_todo(id)
    self.todos.delete_at(id)
  end
end