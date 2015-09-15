require 'spec_helper'
require 'hypothesis-client/helpers'

describe HypothesisClient::Helpers::Uris::Perseids do

  context "successful match" do 
    it 'mapped and created the uri' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://sosol.perseids.org/sosol/test")

      mapped = HypothesisClient::Helpers::Uris::Perseids.new("http://sosol.perseids.org/sosol/publications/12018/epi_cts_identifiers/15754/preview", target) 

      expect(mapped.can_match).to be true 
      expect(mapped.uris).to match_array([])
    end
  end

  context "failed match" do 

    it 'failed to map' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://sosol.perseids.org/sosol/test")
      mapped = HypothesisClient::Helpers::Uris::Perseids.new("http://sosol.perseids.org/sosol/publications/12018/epi_cts_identifiers/15754/editxml",target)
      expect(mapped.can_match).to be_falsey
    end

  end
end
