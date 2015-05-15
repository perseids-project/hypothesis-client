module HypothesisClient
  module Helpers
    module Uris
      class Pleiades

        PLEIADES_URI_MATCH = /(http:\/\/pleiades.stoa.org\/places\/\d+)/

        attr_accessor :can_match, :error, :uris, :cts, :text

        def initialize(a_content)
          @content = a_content
          @can_match = false
          @uris = []
          @text = nil
          @cts = nil
          @error = nil
          @content.scan(PLEIADES_URI_MATCH).each do |p|
            @can_match = true
            unless (p =~ /#this$/) 
              p = "#{p}#this"
            end
            @uris << p
          end
        end
      end
    end 
  end
end
