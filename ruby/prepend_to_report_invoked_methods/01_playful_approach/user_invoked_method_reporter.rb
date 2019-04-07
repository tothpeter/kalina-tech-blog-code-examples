# frozen_string_literal: true

# user_invoked_method_reporter.rb
module UserInvokedMethodReporter
  def unused_method1(*)
    puts 'User#unused_method1 was invoked'
    super
  end
end

User.prepend(UserInvokedMethodReporter)
