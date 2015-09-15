require 'spec_helper'
require 'hypothesis-client/helpers'

describe HypothesisClient::Helpers::Uris::VisibleWords do

  context "successful match" do 

    it 'mapped and created the uri' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::VisibleWords.new("visiblewords:JohnDoe_1") 
      expect(mapped.can_match).to be true 
      expect(mapped.uris).to match_array(["http://data.perseus.org/people/visiblewords:johndoe_1#this"])
    end
  end

  context "failed match" do 

    it 'failed to map' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::VisibleWords.new("JohnDoe") 
      expect(mapped.can_match).to be_falsey
    end

  end

end
