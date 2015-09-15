require 'spec_helper'
require 'hypothesis-client/helpers'

describe HypothesisClient::Helpers::Uris::Hypothesis do

  context "successful match" do 

    it 'mapped and created the uri' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped =  HypothesisClient::Helpers::Uris::Hypothesis.new("https://hypothes.is/a/jtsBhicGR_mEoN1tu8I8hw") 
      expect(mapped.can_match).to be true 
      expect(mapped.uris).to match_array(["https://hypothes.is/a/jtsBhicGR_mEoN1tu8I8hw"])
    end
  end

  context "failed match" do 

    it 'failed to map' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::Hypothesis.new("http://example.org") 
      expect(mapped.can_match).to be_falsey
    end

  end
end
