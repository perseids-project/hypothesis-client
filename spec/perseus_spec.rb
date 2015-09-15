require 'spec_helper'
require 'hypothesis-client/helpers'

describe HypothesisClient::Helpers::Uris::Perseus do

  context "successful match" do 

    it 'mapped and created the uri and urn' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::Perseus.new("http://data.perseus.org/citations/urn:cts:greekLit:tlg0012.tlg001.perseus-grc1:1\nAbas") 
      expect(mapped.can_match).to be true 
      expect(mapped.uris).to match_array(["http://data.perseus.org/citations/urn:cts:greekLit:tlg0012.tlg001.perseus-grc1:1"])
      expect(mapped.cts).to match_array([ { 'uri' => "http://data.perseus.org/citations/urn:cts:greekLit:tlg0012.tlg001.perseus-grc1:1",
                                            'type' => 'http://lawd.info/ontology/Citation',
                                            'textgroup' => 'urn:cts:greekLit:tlg0012',
                                            'work' => 'urn:cts:greekLit:tlg0012.tlg001',
                                            'version' => 'urn:cts:greekLit:tlg0012.tlg001.perseus-grc1',
                                            'passage' => '1' } ])
      expect(mapped.text).to eq 'Abas'
    end
  end

  context "failed match" do 

    it 'mapped' do
      target = double("target")
      allow(target).to receive(:uris).and_return("http://data.perseus.org/people/smith:alexander-1")
      mapped = HypothesisClient::Helpers::Uris::Perseus.new("http://example.org/place") 
      expect(mapped.can_match).to be_falsey
    end

  end
end
