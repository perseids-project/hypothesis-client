module HypothesisClient
  module Helpers
    module Uris
      class PerseusAndHypothesis

        PERSEUS_URI = Regexp.new("http:\/\/data.perseus.org\/citations\/urn:cts:[^\S\n]+" )
        HYPOTHESIS_URI = /^(https:\/\/hypothes\.is\/a\/[^\/]+)$/

        attr_accessor :can_match, :error, :uris, :cts, :text
        def initialize(a_content,a_target=nil)
          @content = a_content
          @can_match = false
          @text = "#{@content}"
          @cts = []
          @uris = []
          @error = nil
          errors = []
 
          @content.scan(PERSEUS_URI).each do |u|
            begin
              @cts << HypothesisClient::Helpers::Uris::Perseus.parse_urn(u)
              # we want any text that isn't part of the uris
              @text.sub!(u,'')
              @text.sub!(/^\n/,'')
              @text.sub!(/\n$/,'')
              @text.sub!(/\n/,' ')
            rescue => e
              errors << e.to_s
            end
          end
          # now look for hypothesis uri
          @content.scan(HYPOTHESIS_URI).each do |p|
            u = p[0]
            u = p[0]
            @uris << u
          end
          if (errors.length > 0) 
            @error = errors.join("\n")
          end
          @can_match = @uris.length > 0 && @cts.length > 0
        end

      end  #end class
    end
  end
end
