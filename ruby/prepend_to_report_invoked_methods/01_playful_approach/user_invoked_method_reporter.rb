# frozen_string_literal: true

module UserInvokedMethodReporter
  def unused_method_from_class(*)
    puts 'User#unused_method_from_class was invoked'
    super
  end
end

User.prepend(UserInvokedMethodReporter)
