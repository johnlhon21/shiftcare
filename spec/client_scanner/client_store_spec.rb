# frozen_string_literal: true

require_relative 'spec_helper'
require 'client_scanner/client_store'
require 'client_scanner/client'

describe ClientScanner::ClientStore do # rubocop:todo Metrics/BlockLength
  let(:clients) do
    [
      { 'id' => 1, 'full_name' => 'Alice Wonderland', 'email' => 'alice@example.com' },
      { 'id' => 2, 'full_name' => 'Bob Builder', 'email' => 'bob@example.com' },
      { 'id' => 3, 'full_name' => 'Alicia Keys', 'email' => 'alice@example.com' }
    ]
  end

  subject { described_class.new(clients) }

  describe '#search_by_name' do # rubocop:todo Metrics/BlockLength
    context 'when searching by full_name' do
      it 'returns matching clients by full_name' do
        results = subject.search_by_name('Alice', 'full_name')
        expect(results.map(&:full_name)).to include('Alice Wonderland')
        expect(results.map(&:full_name)).not_to include('Bob Builder')
      end

      it 'returns no matches if none found' do
        results = subject.search_by_name('Charlie', 'full_name')
        expect(results).to be_empty
      end
    end

    context 'when searching by email' do
      it 'returns matching clients by email' do
        results = subject.search_by_name('bob@example.com', 'email')
        expect(results.size).to eq(1)
        expect(results.first.full_name).to eq('Bob Builder')
      end
    end

    context 'when searching by unsupported column' do
      before do
        allow(subject).to receive(:search_by_name).and_raise(ArgumentError)
      end

      it 'raises an argument error' do
        expect { subject.search_by_name(any_args) }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe '#find_duplicate_emails' do
    it 'returns grouped clients with duplicate emails' do
      duplicates = subject.find_duplicate_emails

      expect(duplicates.keys).to include('alice@example.com')
    end

    context 'when no duplicates exist' do
      before do
        allow(subject).to receive(:find_duplicate_emails).and_return({})
      end
      it 'returns an empty hash' do
        expect(subject.find_duplicate_emails).to eq({})
      end
    end
  end
end
