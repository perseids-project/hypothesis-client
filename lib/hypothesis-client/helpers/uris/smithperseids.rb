module HypothesisClient
  module Helpers
    module Uris
      class SmithPerseids

        PERSEIDS_SITE_URI = Regexp.new('http://(www.)?perseids.org/sites/smiths/')
        TEXT_CTS = "urn:cts:pdlrefwk:viaf88890045.003.perseus-eng1"
        PERSON_URI = "http://data.perseus.org/people/smith:"
        BIO_ENTRY_MATCH = Regexp.new('http://(?:www.)?perseids.org/sites/smiths/(.*?)/(.*?)\.html')

        attr_accessor :can_match, :error, :uris, :cts, :text

        def initialize(a_content,a_target=nil)
          @content = a_content
          @can_match = false
          @text = nil
          @cts = []
          @uris = []
          if (PERSEIDS_SITE_URI.match(@content))
            @can_match = true
            parts =  BIO_ENTRY_MATCH.match(@content)
            if (parts) 

              # normalize the person - should be lower case
              entry = parts[1]
              name = parts[2]

              @uris = ["#{PERSON_URI}#{name.sub(/_/,'-')}#this"]
              @cts = [ "#{TEXT_CTS}:#{entry}.#{name}" ]
            else
              @error = "Unable to parse smith bio entry" 
            end
          end
        end
      end
    end 
  end
end
