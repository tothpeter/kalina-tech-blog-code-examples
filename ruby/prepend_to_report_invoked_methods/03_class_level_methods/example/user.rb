# frozen_string_literal: true

class User
  def unused_method_from_class(param1)
    puts "Original impl with: #{param1}"
  end

  def self.unused_method_from_class(param1)
    puts "Original impl with: #{param1}"
  end
end
