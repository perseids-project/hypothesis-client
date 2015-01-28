# a prototype of a mapper module which takes
# a Hypothes.is annotation which adheres to a pre-defined
# set of rules for tagging and contents and represents this
# as an OA Annotation (JSON-LD serialization) using the 
# LAWD and SNAP ontology. See https://github.com/PerseusDL/perseids_docs/issues/212
module HypothesisApi::MapperPrototype

  class JOTH

    # some hardcoded URIs and match strings for the mapping
    PERSEUS_URI = Regexp.new("http:\/\/data.perseus.org\/citations\/urn:cts:[^\S]+" )
    SMITH_HOPPER_URI = Regexp.new('Perseus:text:1999.04.0104')
    SMITH_TEXT_CTS = "urn:cts:pdlrefwk:viaf88890045.003.perseus-eng1"
    SMITH_PERSON_URI = "http://data.perseus.org/people/smith:"
    SMITH_BIO_MATCH = Regexp.new('(\w+)-bio(-\d+)?')
    SMITH_BIO_ENTRY_MATCH = Regexp.new('entry=(\w+)-bio(-\d+)?')
    PLEIADES_URI_MATCH = /(http:\/\/pleiades.stoa.org\/places\/\d+)/
    ONTO_MAP = {
      'adoptedfamilyrelationship' => 'snap:AdoptedFamilyRelationship',
      'ancestor' => 'snap:AncestorOf',
      'aunt' => 'snap:AuntOf',
      'brother' => 'snap:BrotherOf',
      'child' => 'snap:ChildOf',
      'claimedfamilyrelationship' => 'snap:ClaimedFamilyRelationship',
      'cousin' => 'snap:CousinOf',
      'daughter' => 'snap:DaugherOf',
      'descendent' => 'snap:DescendentOf',
      'father' => 'snap:FatherOf',
      'fosterfamilyrelationship' => 'snap:FosterFamilyRelationship',
      'grandchild' => 'snap:GrandchildOf',
      'granddaughter' => 'snap:GranddaughterOf',
      'grandfather' => 'snap:GranfatherOf',
      'grandmother' => 'snap:GrandmotherOf',
      'grandparent' => 'snap:GrandparentOf',
      'grandson' => 'snap:GrandsonOf',
      'greatgrandfather' => 'snap:GreatGrandfatherOf',
      'greatgrandmother' => 'snap:GreatGrandmotherOf',
      'greatgrandparent' => 'snap:GreatGrandparentOf',
      'household' => 'snap:HouseHoldOf',
      'inlawfamilyrelationship' => 'snap:InLawFamilyRelationship',
      'maternalfamilyrelationship' => 'snap:MaternalFamilyRelationship',
      'mother' => 'snap:MotherOf',
      'nephew' => 'snap:NephewOf',
      'niece' => 'snap:NieceOf',
      'parent' => 'snap:ParentOf',
      'paternalfamilyrelationship' => 'snap:PaternalFamilyRelationship',
      'sibling' => 'snap:SiblingOf',
      'sister' => 'snap:SisterOf',
      'slave' => 'snap:SlaveOf',
      'son' => 'snap:SonOf',
      'stepfamilyrelationship' => 'snap:StepFamilyRelationship',
      'uncle' => 'snap:UncleOf',
      'companion' => 'perseusrdf:CompanionOf',
      'enemy' => 'perseusrdf:EnemyOf',
      'wife' => 'perseusrdf:WifeOf',
      'husband' => 'perseusrdf:HusbandOf'
    }

    OA_CONTEXT =  {
      "oa" => "http://www.w3.org/ns/oa#",
      "cnt" => "http://www.w3.org/2011/content#",
      "dc" => "http://purl.org/dc/elements/1.1/",
      "dcterms" => "http://purl.org/dc/terms/",
      "dctypes" => "http://purl.org/dc/dcmitype/",
      "foaf" => "http://xmlns.com/foaf/0.1/",
      "rdf"  => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs" => "http://www.w3.org/2000/01/rdf-schema#",
      "skos" => "http://www.w3.org/2004/02/skos/core#",
      "snap" => "http://onto.snapdrgn.net/snap#",
      "lawd" => "http://lawd.info/ontology/",
      "perseusrdf" => "http://data.perseus.org/rdfvocab/addons/",
      "hasBody" => {"@type" => "@id", "@id" => "oa:hasBody"},
      "hasTarget" => {"@type" => "@id", "@id" => "oa:hasTarget"},
      "hasSource" => {"@type" => "@id", "@id" => "oa:hasSource"},
      "hasSelector" => {"@type" => "@id", "@id" => "oa:hasSelector"},
      "hasState" => {"@type" => "@id", "@id" => "oa:hasState"},
      "hasScope" => {"@type" => "@id", "@id" => "oa:hasScope"},
      "annotatedBy" => {"@type" => "@id", "@id" => "oa:annotatedBy"},
      "serializedBy" => {"@type" => "@id", "@id" => "oa:serializedBy"},
      "motivatedBy" => {"@type" => "@id", "@id" => "oa:motivatedBy"},
      "equivalentTo" => {"@type" => "@id", "@id" => "oa:equivalentTo"},
      "styledBy" => {"@type" => "@id", "@id" => "oa:styledBy"},
      "cachedSource" => {"@type" => "@id", "@id" => "oa:cachedSource"},
      "conformsTo" => {"@type" => "@id", "@id" => "dcterms:conformsTo"},
      "default" => {"@type" => "@id", "@id" => "oa:default"},
      "item" => {"@type" => "@id", "@id" => "oa:item"},
      "first" => {"@type" => "@id", "@id" => "rdf:first"},
      "rest" =>  {"@type" => "@id", "@id" => "rdf:rest", "@container" => "@list"},
      "chars" => "cnt:chars",
      "bytes" => "cnt:bytes",
      "format" => "dc:format",
      "annotatedAt" => "oa:annotatedAt",
      "serializedAt" => "oa:serializedAt",
      "when" => "oa:when",
      "value" => "rdf:value",
      "start" => "oa:start",
      "end" => "oa:end",
      "exact" => "oa:exact",
      "prefix" => "oa:prefix",
      "suffix" => "oa:suffix",
      "label" => "rdfs:label",
      "name" => "foaf:name",
      "mbox" => "foaf:mbox",
      "styleClass" => "oa:styleClass"
    }

    # Map the data as provided by Hypothes.is to our expected data model
    # @param agent the URI for the hypothes.is software agent
    # @param source the URI of the original hypothes.is annotation
    # @param data the Hypothes.is data
    # @param format expected output format -- only HypothesisApi::Client::FORMAT_OALD supported
    def map(agent,source,data,format)
      response = {} 
      response[:errors] = []
      model = {}
      # first some general parsing to pick the pieces we want from
      # the hypothes.is data object
      begin
        model[:agentUri] = agent
        model[:sourceUri] = source
        # if we have updated at, use that as annotated at, otherwise use created 
        model[:date] = data["updated"] ? data["updated"]: data["created"]
        body_tags = {}
        data["tags"].each do |t|
          # we do some normalization here in case tags merged
          t.split(/\s+/).each do |s|
            body_tags[s] = 1
          end # end split iteration
        end #end data tags iteration
        # we only support a single target for now so last gets kept
        data["target"].each do |t|
          model[:targetUri] = t["source"]
          model[:targetSelector] = {}
          # we only want the textquoteselector for now
          t["selector"].each do |s|
            if ! s.nil? && s["type"] == 'TextQuoteSelector'
              model[:targetSelector] = s
            end #end test on quote selector
          end #end iteration of selectors
        end #end iteration of targets
      rescue => e
        response[:errors] << e.to_s
      end # end begin on parsing data

      # and here is where we hack for the Journey of the Hero data model
      if SMITH_HOPPER_URI.match(data["uri"])
        parts = SMITH_BIO_ENTRY_MATCH.match(data["uri"])
        if (parts) 
           model[:motivation] ="oa:identifying"
           model[:targetPerson] = "#{SMITH_PERSON_URI}#{parts[1]}#{parts[2]}#this" 
           model[:targetCTS] = "#{SMITH_TEXT_CTS}:#{parts[1]}#{parts[2]}"
           model[:bodyUri] = ""
           if body_tags[:person] && data["text"] =~ /(.*?)-bio(-\d+)?/
             if body_tags["relation"]
                model[:isRelation] = true
                body_tags.keys.each do |k|
                    model[:relationTerm] = ONTO_MAP[k.downcase]        
                end #end iteration of tags
                unless model[:relationTerm]
                  response[:errors] << "Invalid relation tag" 
                end
             else
               response[:errors] << "Missing relation tag" 
             end
           elsif body_tags[:place] && PLEIADES_URI_MATCH.match(data["text"])
             # we support just pleiades uris for now
             data["text"].scan(PLEIADES_URI_MATCH).each do |p|
               model[:bodyUri] << "#{p}#this"
             end
             unless model[:bodyUri].length > 0
               response[:errors] << "No valid place uris found"
             end
           elsif body_tags["citation"] && PERSEUS_URI.match(data["text"])
             model[:isCitation] = true
             # we support just perseus uris for now
             data["text"].scan(PERSEUS_URI).each do |u|
              model[:bodyUri] << u
             end
             unless model[:bodyUri].length > 0
               response[:errors] << "No valid citation uris found"
             end
           # otherwise we assume it's a plain link
           else 
             model[:motivation] ="oa:linking"
             data["text"].scan(URI.regexp) do |*matches|
               model[:bodyUri] << $&
             end
             unless model[:bodyUri].length > 0
               response[:errors] << "No valid links found"
             end
           end
        else 
          response[:errors] << "Unable to parse smith bio entry"
        end #end test on person part of uri
      else 
        response[:errors] << "Unable to parse smith text entry"
      end #end test on original target uri 
      if (response[:errors].length == 0)
        if (format == HypothesisApi::Client::FORMAT_OALD)
          response[:oa] = to_oa(model)
        else
          response[:errors] << "Only OA JSON-LD format supported"
        end
      end
      response
    end

    def to_oa(obj)
      oa = {}
      oa['@context'] = OA_CONTEXT
      # leave oa[@id] and oa[@annotatedBy] to be set from calling code?
      # ideally we would preserve the provenance chain better here
      oa['@id'] = ""
      oa['annotatedBy'] = "" 
      oa['@type'] = "oa:Annotation"
      oa['dcterms:source'] = obj[:sourceUri]
      oa['dcterms:title'] = make_title(obj)
      oa['annotatedAt'] = obj[:date]
      oa['motivatedBy'] = obj[:motivation]
      oa['serializedBy'] = {}  
      oa['serializedBy']['@id'] = obj[:agentUri]
      oa['serializedBy']['@type'] = "prov:SoftwareAgent"
      oa['hasTarget'] = {
        "@id" => "", # generate a uuid
        "@type" => "oa:SpecificResource", 
        "hasSource" => { '@id' => obj[:targetCTS] },
        "hasSelector" => {
          "@id" => "", # generate a uuid
          "@type" => "oa:TextQuoteSelector",
          "exact" => obj[:targetSelector]["exact"],
          "prefix" => obj[:targetSelector]["prefix"],
          "suffix" => obj[:targetSelector]["suffix"]
        }
      }
      ## THIS TECHNICALLY ISN'T VALID OA to EMBED A JSON-LD named graph without
      ## a graph id but I'm having trouble caring...
      if obj[:isRelation]
        oa['hasBody'] = [ 
          { "@graph"  => [ 
            {
              "@id" =>  obj[:targetPerson],
              "snap:has-bond" =>  {
                "@id" => "" # generate a uuid
               }
            },
            {
              "@id" => "", # uuid generated above
              "@type" => obj[:relationTerm],
              "snap:bond-with" => {
                "@id" => obj[:bodyUri]
              }
            } ] 
          } 
        ]
      elsif obj[:isCitation]
         # oa[:hasBody] = "" # TODO graph of the citation relationships
         oa['hasBody'] = { "@id" => obj[:bodyUri] }
      else
         oa['hasBody'] = { "@id" => obj[:bodyUri] }
      end
      oa
    end

    # make a descriptive title for the annotation in the form of
    # bodyUri <is linked to|identifies> <text> [as <relationship>] in bodyUri
    def make_title(obj) 
      motivation_text = obj[:motivation] == 'oa:linking' ? 'is linked to' : 'identifies'
      relation_text = obj[:relationTerm] ? " as #{obj[:relationTerm]} " : ""
      "#{obj[:bodyUri]} #{motivation_text} #{obj[:targetSelector]['exact']}#{relation_text} in #{obj[:targetCTS]}"
    end

  end #end JOTH class
end #end Mapper Modul
