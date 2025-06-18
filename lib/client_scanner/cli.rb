# frozen_string_literal: true

require 'thor'
require_relative 'loader'
require_relative 'client_store'

module ClientScanner
  # CLI for ClientScanner
  class CLI < Thor
    default_command :help

    desc 'search --query QUERY [--file FILE] [--column COLUMN]', 'Search by full_name or email'
    method_option :query, aliases: '-q', required: true
    method_option :column, aliases: '-c', default: 'full_name'
    method_option :file, aliases: '-f', default: 'data/clients.json'
    def search # rubocop:todo Metrics/AbcSize
      store = ClientStore.new(Loader.load(options[:file]))
      results = store.search_by_name(options[:query], options[:column])

      if results.empty?
        puts "No clients found matching '#{options[:query]}' " \
        "in column '#{options[:column]}'."
      else
        results.each { |c| puts "#{c.full_name} (#{c.email})" }
      end
    rescue StandardError => e
      puts e.message
    end

    desc 'duplicates [--file FILE]', 'Find duplicate client emails'
    method_option :file, aliases: '-f', default: 'data/clients.json'
    def duplicates # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
      store = ClientStore.new(Loader.load(options[:file]))
      duplicates = store.find_duplicate_emails

      if duplicates.empty?
        puts 'No duplicate emails found.'
      else
        duplicates.each do |email, clients|
          puts "\nDuplicate Email: #{email}"
          clients.each { |c| puts "  - #{c.full_name} (ID: #{c.id})" }
        end
      end
    rescue StandardError => e
      puts e.message
    end
  end
end
