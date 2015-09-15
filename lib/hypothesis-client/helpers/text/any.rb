module HypothesisClient
  module Helpers
    module Text
      class Any

        attr_accessor :can_match, :error, :text

        def initialize(a_content)
          @can_match = true
          @content = a_content
          @text = "#{@content}"
          # strip leading and trailing spaces
          @text.sub!(/^[\n|\s]+/,'',)
          @text.sub!(/^[\n|\s]+$/,'')
        end
      end
    end 
  end
end
