module HypothesisClient
  module Helpers
    module Uris
      class Any

        attr_accessor :can_match, :error, :uris, :cts, :text

        def initialize(a_content,a_target=nil)
          @content = a_content
          @can_match = false 
          @uris = []
          @text = "#{@content}"
          @cts = nil
          @error = nil
          @content.scan(URI.regexp) do |*matches|
            @can_match = true
            u = $&
            @uris << u
            # keep any text that isn't part of the uris
            @text.sub!(u,'')
            @text.sub!(/^\n/,'')
            @text.sub!(/\n$/,'')
          end
        end
      end
    end 
  end
end
