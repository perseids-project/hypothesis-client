require 'spec_helper'
require 'hypothesis-client/helpers'

describe HypothesisClient::Helpers::Text::SNAP do

  context "successful single match" do 
    it 'can match and find term' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped =HypothesisClient::Helpers::Text::SNAP.new("grandfather", target)

      expect(mapped.can_match).to be true 
      expect(mapped.relation_terms).to match_array(["snap:GrandfatherOf"])
    end
  end

  context "correctly failed single match" do 

    it 'can match but no term' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Text::SNAP.new("grandpere",target)
      expect(mapped.can_match).to be true 
      expect(mapped.relation_terms).to match_array([])
    end

  end

  context "successful multiple match" do 

    it 'can match and find terms' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Text::SNAP.new(" grandfather\n sister",target)
      expect(mapped.can_match).to be true 
      expect(mapped.relation_terms).to match_array(["snap:GrandfatherOf", "snap:SisterOf"])
    end

  end

end
