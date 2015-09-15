require 'spec_helper'
require 'hypothesis-client/helpers'

describe HypothesisClient::Helpers::Uris::Pleiades do

  context "successful match" do 

    it 'mapped and created the uri' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::Pleiades.new("http://pleiades.stoa.org/places/579885") 
      expect(mapped.can_match).to be true 
      expect(mapped.uris).to match_array(["http://pleiades.stoa.org/places/579885#this"])
    end
  end

  context "successful match with this" do 

    it 'mapped and created the uri' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::Pleiades.new("http://pleiades.stoa.org/places/579885#this") 
      expect(mapped.can_match).to be true 
      expect(mapped.uris).to match_array(["http://pleiades.stoa.org/places/579885#this"])
    end
  end

  context "successful match with multiple" do 

    it 'mapped and created the uri' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::Pleiades.new("http://pleiades.stoa.org/places/579885#this http://pleiades.stoa.org/places/579886" ) 
      expect(mapped.can_match).to be true 
      expect(mapped.uris).to match_array(["http://pleiades.stoa.org/places/579885#this","http://pleiades.stoa.org/places/579886#this" ])
    end
  end

  context "failed match" do 

    it 'failed to map' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::Pleiades.new("http://example.org/place") 
      expect(mapped.can_match).to be_falsey
    end

  end
end
