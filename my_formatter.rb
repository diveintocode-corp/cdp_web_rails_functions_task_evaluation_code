class MyFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :start, :stop
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
  
  def stop(notification)
    if notification.examples.count == 0
      @output << "## Evaluation could not be performed. Please check for syntax errors in your code.\n### Common syntax errors\n- Typos in code.\n- The `end` is missing."
    end
  end
end
