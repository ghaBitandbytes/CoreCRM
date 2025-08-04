ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
end

# ✅ Include Devise test helpers for integration tests
class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

# ✅ Include Devise test helpers for controller tests (optional but safer)
class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
