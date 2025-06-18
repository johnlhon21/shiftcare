# frozen_string_literal: true

ENV['THOR_SILENCE_DEPRECATION'] = 'true'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Optional: show documentation format when running only one file
  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :defined
  config.color = true
end
