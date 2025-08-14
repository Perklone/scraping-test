# frozen_string_literal: true

require 'rspec'
require_relative '../services/extractor'

RSpec.describe Extractor do
  let(:extractor) { Extractor.new }
  let(:sample_output) { 'files/expected-array.json' }

  describe '#extract' do
    context 'Sample HTML Parsing' do
      it 'extracts 47 artworks' do
        sample_file = File.read(sample_output)
        sample_json = JSON.parse(sample_file)

        result = extractor.extract('files/van-gogh-paintings.html')

        expect(result.class).to eq(Hash)
        expect(result[:artworks].length).to eq(sample_json['artworks'].length)
      end
    end

    context 'Non-Sample HTML Parsing' do
      let(:monet_file) { 'files/monet-paintings.html' }

      it 'extracts artworks' do
        result = extractor.extract(monet_file)

        expect(result.class).to eq(Hash)
        expect(result[:artworks].length).to eq(49)
      end
    end

    context 'Contains proper properties' do
      let(:vangogh_file) { 'files/van-gogh-paintings.html' }
      let(:result) { extractor.extract(vangogh_file)[:artworks] }

      it 'has valid artwork names' do
        result.each do |artwork|
          expect(artwork[:name]).to be_a(String)
          expect(artwork[:name]).not_to be_empty
        end
      end

      it 'has valid links' do
        result.each do |artwork|
          expect(artwork[:link]).to be_a(String)
          expect(artwork[:link]).to start_with('https://www.google.com')
        end
      end

      it 'has extensions when available' do
        artworks_with_dates = result.select { |a| a[:extensions] }
        expect(artworks_with_dates).not_to be_empty

        artworks_with_dates.each do |artwork|
          expect(artwork[:extensions]).to be_an(Array)
          expect(artwork[:extensions].first).to match(/^\d{4}$/)
        end
      end

      xit "contains image" do
        result.each do |artwork|
          expect(artwork[:image]).to be_a(String)
          expect(artwork[:image]).not_to be_empty
        end
      end
    end
  end
end
