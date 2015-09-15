module HypothesisClient
  module Helpers
    module Text
      class SNAP

        attr_accessor :relation_terms 

        def initialize(a_content)
          @ontology => HypothesisClient::Helpers::Ontology::SNAP.new,
          @relation_terms = []
          a_content.split(/\s+/).each do |t|
            if @ontology.get_term(t)
              @relation_terms << t
            end
          end
        end
      end
    end 
  end
end
