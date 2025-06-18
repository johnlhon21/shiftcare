# frozen_string_literal: true

require 'json'

module ClientScanner
  # Loader class to load JSON data from a file
  class Loader
    def self.load(path)
      raise "File not found: #{path}" unless File.exist?(path)
      raise "Invalid file type: #{path}" unless File.extname(path) == '.json'

      collection = JSON.parse(File.read(path))
      raise 'Invalid JSON format' unless collection.is_a?(Array)

      collection.each do |data|
        raise 'Each item must be a hash' unless data.is_a?(Hash)
        # Ensure required keys are present
        unless data.key?('id') && data.key?('full_name') && data.key?('email')
          raise 'Missing required keys'
        end
      end

      collection
    rescue JSON::ParserError => e
      raise "JSON parsing error: #{e.message}"
    rescue StandardError => e
      raise "Error processing data: #{e.message}"
    end
  end
end
