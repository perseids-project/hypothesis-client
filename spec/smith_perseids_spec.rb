require 'spec_helper'
require 'hypothesis-client/helpers'

describe HypothesisClient::Helpers::Uris::SmithPerseids do

  context "successful match" do 

    it 'mapped and created the uri' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://perseids.org/sites/smiths/Z/zeus_1.html")
      mapped = HypothesisClient::Helpers::Uris::SmithPerseids.new("http://perseids.org/sites/smiths/Z/zeus_1.html",target)
      expect(mapped.can_match).to be true 
      expect(mapped.uris).to match_array(["http://data.perseus.org/people/smith:zeus-1#this"])
      expect(mapped.cts).to match_array(["urn:cts:pdlrefwk:viaf88890045.003.perseus-eng1:Z.zeus_1"])
    end
  end

  context "failed match" do 

    it 'failed to map' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::Smith.new("alexander") 
      expect(mapped.can_match).to be_falsey
    end

  end
end
