ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'

# Extend the Time class so that we can offset the time that 'now'
# returns.  This should allow us to effectively time warp for functional
# tests that require limits per hour, what not.
class Time #:nodoc:
  class <<self
    attr_accessor :testing_offset
    alias_method :real_now, :now
    def now
      real_now - testing_offset
    end
    alias_method :new, :now
  end
end
Time.testing_offset = 0

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Time warp to the specified time for the duration of the passed block
  def pretend_now_is(time)
    begin
      Time.testing_offset = Time.now - time
      yield
    ensure
      Time.testing_offset = 0
    end
  end
end
