require 'rspec'
require_relative '../results/extractor'

RSpec.describe Extractor do
  let(:extractor) { Extractor.new }

  describe '#extract' do
    context "Sample HTML Parsing" do
      it 'extracts 47 artworks' do
        sample_file = File.read("files/expected-array.json")
        sample_json = JSON.parse(sample_file)

        result = extractor.extract('files/van-gogh-paintings.html')

        expect(result.class).to eq(Hash)
        expect(result[:artworks].length).to eq(sample_json["artworks"].length)
      end
    end
  end
end