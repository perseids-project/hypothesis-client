require 'spec_helper'
require 'hypothesis_api/client'
require 'hypothesis_api/mapper_prototype'

describe HypothesisApi::MapperPrototype do
  let(:client) { HypothesisApi::Client.new(HypothesisApi::MapperPrototype::JOTH.new) }

  context "basic test" do 
    input = File.read(File.join(File.dirname(__FILE__), 'support', 'test1.json')) 
    let(:mapped) { client.map("test",JSON.parse(input))}

    it 'produced oa' do 
      expect(mapped[:errors]).to match_array([])
      expect(mapped[:oa]).to be_truthy
    end

    it 'mapped the source uri' do
      expect(mapped[:oa]["dcterms:source"]).to eq('test')
    end

    it 'mapped the body text' do
      expect(mapped[:oa]["hasBody"]["@id"]).to eq("http://data.perseus.org/citations/urn:cts:greekLit:tlg0012.tlg001:6.222")
    end

    it 'mapped the sourceText' do 
      expect(mapped[:oa]["hasTarget"]["hasSource"]["@id"]).to eq("#{HypothesisApi::MapperPrototype::JOTH::SMITH_TEXT_CTS}:diomedes-1")
    end
    
    it 'mapped the motivation' do
      expect(mapped[:oa]["motivatedBy"]).to eq("oa:identifying")
    end

    it 'made a title' do
      expect(mapped[:oa]["dcterms:title"]).to eq("http://data.perseus.org/citations/urn:cts:greekLit:tlg0012.tlg001:6.222 identifies II. 6.222 in #{HypothesisApi::MapperPrototype::JOTH::SMITH_TEXT_CTS}:diomedes-1")
    end

  end
end
