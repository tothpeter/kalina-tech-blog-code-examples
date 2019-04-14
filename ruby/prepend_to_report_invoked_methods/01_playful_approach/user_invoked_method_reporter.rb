# frozen_string_literal: true

module UserInvokedMethodReporter
  def unused_method1(*)
    puts 'User#unused_method1 was invoked'
    super
  end
end

User.prepend(UserInvokedMethodReporter)
