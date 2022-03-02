class MyFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :start
  def initialize(output)
    @output = output
  end

  def start(notification)
    @output << "---\ntitle: Feedback on the assignment\n---\n"
  end

  def example_passed(notification)
    @output << "- ✅ #{notification.example.description}\n"
  end

  def example_failed(notification)
    @output << "- [ ] ❌ #{notification.example.description}\n"
  end
end
