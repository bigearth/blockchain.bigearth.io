require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
reporter_options = { color: true, slow_count: 5 }
# Optional slow_threshold
# reporter_options = { color: true, slow_count: 5, slow_threshold: 0.01 }
# * https://github.com/kern/minitest-reporters
# * http://chriskottom.com/blog/2014/06/dress-up-your-minitest-output/
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end
