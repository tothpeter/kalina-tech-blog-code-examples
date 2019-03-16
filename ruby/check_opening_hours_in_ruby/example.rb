# frozen_string_literal: true

class MyBankOpeningHours
  include Comparable

  attr_reader :opens_at_hour, :opens_at_minute, :closes_at_hour, :closes_at_minute

  def initialize(opens_at: '8:00', closes_at: '17:40')
    @opens_at_hour, @opens_at_minute   = opens_at.split(':').map(&:to_i)
    @closes_at_hour, @closes_at_minute = closes_at.split(':').map(&:to_i)
  end

  def <=>(other)
    return nil unless comparable_with?(other)

    if too_early?(other)
      1
    elsif too_late?(other)
      -1
    else
      0
    end
  end

  private

  def comparable_with?(other_object)
    other_object.respond_to?(:hour) && other_object.respond_to?(:min)
  end

  def too_early?(time)
    time.hour * 60 + time.min < opens_at_hour * 60 + opens_at_minute
  end

  def too_late?(time)
    closes_at_hour * 60 + closes_at_minute < time.hour * 60 + time.min
  end
end
