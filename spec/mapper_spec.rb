require 'spec_helper'
require 'hypothesis_api/client'
require 'hypothesis_api/mapper_prototype'

describe HypothesisApi::MapperPrototype do
  let(:client) { HypothesisApi::Client.new(HypothesisApi::MapperPrototype::JOTH.new) }

  context "basic test" do 
    input = File.read(File.join(File.dirname(__FILE__), 'support', 'test1.json')) 
    let(:model) { client.transform_data('test',input) }

    it 'mapped the source uri' do
      expect(model[:sourceUri]).to eq('test')
    end

    it 'mapped the body text' do
      expect(model[:bodyText]).to eq("http://data.perseus.org/citations/urn:cts:greekLit:tlg0012.tlg001:6.222")
    end

    it 'mapped the tag' do
      expect(model[:bodyTags]["citation"]).to eq(1)
    end

    it 'mapped the orig target' do
      expect(model[:origTarget]).to eq("http://www.perseus.tufts.edu/hopper/text?doc=Perseus:text:1999.04.0104:alphabetic+letter=D:entry+group=11:entry=diomedes-bio-1")
    end
 
    it 'mapped the sourcePerson' do
      expect(model[:sourcePerson]).to eq("http://data.perseus.org/people/smith:diomedes-1")
    end
   
    it 'mapped the sourceText' do 
      expect(model[:sourceText]).to eq("urn:cts:pldrefwk:smith.bio.perseus-eng1:diomedes-1")
    end
    
    it 'mapped the motivation' do
      expect(model[:motivation]).to eq("oa:identifying")
    end

    it 'mapped the bodyUri' do
      expect(model[:bodyUri][0]).to eq("http://data.perseus.org/citations/urn:cts:greekLit:tlg0012.tlg001:6.222")
    end
  end
end
