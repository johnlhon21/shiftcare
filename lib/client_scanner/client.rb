# frozen_string_literal: true

module ClientScanner
  # Class to handle data sets
  class Client
    attr_reader :id, :full_name, :email

    def initialize(attrs)
      attrs = attrs.transform_keys(&:to_sym)

      @id = attrs[:id]
      @full_name = attrs[:full_name]
      @email = attrs[:email]
    end
  end
end
