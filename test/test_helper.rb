ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/autorun"
require "mocha/minitest"
require "securerandom"
require "ostruct"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Ensure Active Record Encryption has keys in test so models with `encrypts`
    # can be created/read without external env/credentials configuration.
    setup do
      encryption = Rails.application.config.active_record.encryption

      encryption.primary_key ||= SecureRandom.hex(32)
      encryption.deterministic_key ||= SecureRandom.hex(32)
      encryption.key_derivation_salt ||= SecureRandom.hex(32)
    end

    # Add more helper methods to be used by all tests here...
  end
end
