# frozen_string_literal: true

require_relative 'spec_helper'
require 'json'
require 'client_scanner/cli'

describe ClientScanner::CLI do # rubocop:todo Metrics/BlockLength
  let(:fixture_path) do
    File.expand_path('../client_scanner/fixtures/clients.json', __dir__)
  end
  let(:full_dataset) { JSON.parse(File.read(fixture_path)) }
  let(:arguments) { %w[search --query John] }

  before do
    allow(ClientScanner::Loader).to receive(:load).and_return(full_dataset)
  end

  subject { described_class.start(arguments) }

  describe '#search' do # rubocop:todo Metrics/BlockLength
    context 'when no file is provided' do # rubocop:todo Metrics/BlockLength
      it 'finds clients by full_name' do
        expect { subject }.to output(/John/).to_stdout
      end

      context 'when column is specified' do
        let(:arguments) { %w[search --query gmail -c email] }

        it 'finds clients by column provided' do
          expect { subject }.to output(/gmail/).to_stdout
        end
      end

      context 'when no query is provided' do
        let(:arguments) { %w[search --query] }

        it 'show argument missing error' do
          expect { subject }.to output(/No value provided/).to_stderr
        end
      end

      context 'when an invalid column is specified' do
        let(:arguments) { %w[search --query John -c invalid_column] }

        it 'shows unsupported column error' do
          expect { subject }.to output(/Unsupported column: invalid_column/)
            .to_stdout
        end
      end

      context 'when no matching clients are found' do
        let(:arguments) { %w[search --query NonExistentClient] }

        it 'outputs a message indicating no clients were found' do
          expect { subject }.to output(/No clients found matching/).to_stdout
        end
      end
    end

    context 'when a file is provided' do # rubocop:todo Metrics/BlockLength
      context 'with a valid file' do
        let(:arguments) { %w[search --query John --file] + [fixture_path] }

        it 'shows matching client are found' do
          expect { subject }.to output(/John/).to_stdout
        end

        context 'when no matching clients are found' do
          let(:arguments) { %w[search --query NonExistentClient] }

          it 'outputs a message indicating no clients were found' do
            expect { subject }.to output(/No clients found matching/).to_stdout
          end
        end
      end

      context 'with a file not found' do
        let(:arguments) { %w[search --query John --file file_not_found] }

        before do
          allow(ClientScanner::Loader).to receive(:load)
            .and_raise(StandardError, 'File not found')
        end

        it 'shows file not found error' do
          expect { subject }.to output(/File not found/).to_stdout
        end
      end

      context 'with a invalid file type' do
        let(:fixture_path) do
          File.expand_path('../client_scanner/fixtures/client.unknown', __dir__)
        end
        let(:arguments) { %w[search --query John --file] + [fixture_path] }
        let(:full_dataset) { nil }

        before do
          allow(ClientScanner::Loader).to receive(:load)
            .and_raise(StandardError, 'Invalid file type')
        end

        it 'shows invalid file type error' do
          expect { subject }.to output(/Invalid file type/).to_stdout
        end
      end

      context 'with a invalid json keys' do
        let(:fixture_path) do
          File.expand_path('../client_scanner/fixtures/invalid_keys.json', __dir__)
        end
        let(:arguments) { %w[search --query John --file] + [fixture_path] }
        let(:full_dataset) { nil }

        before do
          allow(ClientScanner::Loader).to receive(:load)
            .and_raise(StandardError, 'Missing required keys')
        end

        it 'shows invalid file type error' do
          expect { subject }.to output(/Missing required keys/).to_stdout
        end
      end
    end
  end
  describe '#duplicates' do # rubocop:todo Metrics/BlockLength
    context 'when no file is provided' do
      let(:arguments) { %w[duplicates] }

      it 'shows duplicate emails' do
        expect { subject }.to output(/Duplicate Email: jane.smith@yahoo.com/)
          .to_stdout
      end

      context 'when no duplicate emails are found' do
        before do
          unique_data = full_dataset.uniq { |c| c['email'] }
          allow(ClientScanner::Loader).to receive(:load).and_return(unique_data)
        end

        it 'shows no duplicates if all emails are unique' do
          expect { subject }.to output(/No duplicate emails found/).to_stdout
        end
      end
    end

    context 'when a file is provided' do # rubocop:todo Metrics/BlockLength
      context 'with a valid file' do
        let(:arguments) { %w[duplicate --file] + [fixture_path] }

        it 'shows duplicate emails' do
          expect { subject }.to output(/Duplicate Email: jane.smith@yahoo.com/)
            .to_stdout
        end

        context 'when no duplicate emails are found' do
          before do
            unique_data = full_dataset.uniq { |c| c['email'] }
            allow(ClientScanner::Loader).to receive(:load).and_return(unique_data)
          end

          it 'shows no duplicates if all emails are unique' do
            expect { subject }.to output(/No duplicate emails found/).to_stdout
          end
        end
      end

      context 'with a file not found' do
        let(:arguments) { %w[duplicate --file file_not_found] }

        before do
          allow(ClientScanner::Loader).to receive(:load)
            .and_raise(StandardError, 'File not found')
        end

        it 'shows file not found error' do
          expect { subject }.to output(/File not found/).to_stdout
        end
      end

      context 'with a invalid file type' do
        let(:fixture_path) do
          File.expand_path('../client_scanner/fixtures/client.unknown', __dir__)
        end
        let(:arguments) { %w[duplicate --file] + [fixture_path] }
        let(:full_dataset) { nil }

        before do
          allow(ClientScanner::Loader).to receive(:load)
            .and_raise(StandardError, 'Invalid file type')
        end

        it 'shows invalid file type error' do
          expect { subject }.to output(/Invalid file type/).to_stdout
        end
      end

      context 'with a invalid json keys' do
        let(:fixture_path) do
          File.expand_path('../client_scanner/fixtures/invalid_keys.json', __dir__)
        end
        let(:arguments) { %w[duplicate --file] + [fixture_path] }
        let(:full_dataset) { nil }

        before do
          allow(ClientScanner::Loader).to receive(:load)
            .and_raise(StandardError, 'Missing required keys')
        end

        it 'shows invalid file type error' do
          expect { subject }.to output(/Missing required keys/).to_stdout
        end
      end
    end
  end
end
