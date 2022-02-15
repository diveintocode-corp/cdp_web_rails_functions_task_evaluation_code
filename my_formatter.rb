class MyFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :start
  def initialize(output)
    @output = output
  end

  def start(notification)
    @output << "---\ntitle: 課題評価のフィードバック\n---\n"
  end

  def example_passed(notification)
    @output << "- ✅ #{notification.example.description}\n"
  end

  def example_failed(notification)
    @output << "- [ ] ❌ #{notification.example.description}\n"
  end
end
