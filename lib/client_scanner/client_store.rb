# frozen_string_literal: true

require_relative 'client'

module ClientScanner
  # Class to handle a collection of client data
  class ClientStore
    def initialize(collection)
      @data = collection.map { |data| Client.new(data) }
    end

    def search_by_name(query, column)
      case column
      when 'full_name'
        @data.select { |c| c.full_name.downcase.include?(query.downcase) }
      when 'email'
        @data.select { |c| c.email.downcase.include?(query.downcase) }
      else
        raise ArgumentError, "Unsupported column: #{column}"
      end
    end

    def find_duplicate_emails
      grouped = @data.group_by(&:email)

      grouped.select { |_, list| list.size > 1 }
    end
  end
end
