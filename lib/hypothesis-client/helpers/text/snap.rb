module HypothesisClient
  module Helpers
    module Text
      class SNAP

        attr_accessor :relation_terms, :can_match, :error, :uris

        def initialize(a_content,a_target=nil)
          @can_match = a_content != '' && a_target.uris.length > 0
          @uris = a_target.uris
          @ontology = HypothesisClient::Helpers::Ontology::SNAP.new
          @relation_terms = []
          a_content.split(/\s+/).each do |t|
            term = @ontology.get_term(t)
            if term
              @relation_terms << term 
            end
          end
        end
      end
    end 
  end
end
