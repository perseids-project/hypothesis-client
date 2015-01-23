module HypothesisApi::MapperPrototype

  class JOTH

    PERSEUS_URI = Regexp.new("http:\/\/data.perseus.org\/citations\/urn:cts:[^\S]+" )
    SMITH_HOPPER_URI = Regexp.new('Perseus:text:1999.04.0104')
    SMITH_TEXT_CTS = "urn:cts:pldrefwk:smith.bio.perseus-eng1"
    SMITH_PERSON_URI = "http://data.perseus.org/people/smith:"
    SMITH_BIO_MATCH = Regexp.new('(\w+)-bio(-\d+)?')
    SMITH_BIO_ENTRY_MATCH = Regexp.new('entry=(\w+)-bio(-\d+)?')
    PLEIADES_URI_MATCH = /(http:\/\/pleiades.stoa.org\/places\/\d+)/

    def map(model)
      # here is where we hack for smiths
      if SMITH_HOPPER_URI.match(model[:origTarget])
        parts = SMITH_BIO_ENTRY_MATCH.match(model[:origTarget])
        if (parts) 
           model[:sourcePerson] = "#{SMITH_PERSON_URI}#{parts[1]}#{parts[2]}" 
           model[:sourceText] = "#{SMITH_TEXT_CTS}:#{parts[1]}#{parts[2]}"
           if model[:bodyTags][:person] && model[:bodyText] =~ /(.*?)-bio(-\d+)?/
             if model[:bodyTags][:relation]
               # TODO we turn this into a named graph
             end
           elsif model[:bodyTags][:place] && PLEIADES_URI_MATCH.match(model[:bodyText])
               # we support just pleiades uris for now
               model[:bodyText].scan(PLEIADES_URI_MATCH).each do |p|
                 model[:bodyUri] << "#{p}#this"
               end
               model[:motivation] ="oa:identifying"
           elsif model[:bodyTags]["citation"] && PERSEUS_URI.match(model[:bodyText])
               # we support just perseus uris for now
               model[:bodyText].scan(PERSEUS_URI).each do |u|
                 model[:bodyUri] << u
               end
               model[:motivation] ="oa:identifying"
           # otherwise it's a plain link
           else 
             model[:bodyText].scan(URI.regexp) do |*matches|
               model[:bodyUri] << $&
             end
             model[:motivation] ="oa:linking"
           end
        end
      end
      model
    end
  end
end
