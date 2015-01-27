require 'json'
require 'uri'
require 'net/https'

module HypothesisApi

  class Client

    AGENT_URI = 'https://hypothes.is'
    FORMAT_OALD = 1 

    def initialize(mapper)
      @mapper = mapper
    end

    def get(a_uri)
      respobj = {}
      begin
        uri = URI.parse(a_uri)
        id = uri.path.split(/\//).last
        uri.path = "/api/annotations/#{id}"
        http = Net::HTTP.new(uri.host, uri.port) 
        http.use_ssl = true
        headers = {'Accept' => 'application/json'}
        response = http.send_request('GET',uri.request_uri,nil,headers)
        if (response.code == '200') 
          orig_annot = JSON.parse(response.body)
          respobj['mapped'] = transform_data(a_uri,orig_annot)
          respobj['rawdata'] = orig_annot
        else
          respobj = { :is_error  => true,
                      :error => "HTTP #{response.code}",
                      :rawdata => response
                    }
        end
      rescue => e
        respobj = { :is_error  => true,
                    :error => e.backtrace }
      end
      respobj
      
    end

    def transform_data(source,orig_annot)
      model = {}
      begin
        model[:agentUri] = AGENT_URI
        model[:sourceUri] = source
        model[:origTarget] = orig_annot["uri"]
        # if we have updated at, use that as annotated at, otherwise use created 
        model[:date] = orig_annot["updated"] ? orig_annot["updated"]: orig_annot["created"]
        model[:bodyText] = orig_annot["text"]
        model[:bodyTags] = {}
        model[:bodyUri] = []
        orig_annot["tags"].each do |t|
          model[:bodyTags][t] = 1
        end
        orig_annot["target"].each do |t|
          target = {} 
          target[:targetUri] = t["source"]
          target[:TextQuoteSelector] = {}
          # we only want the textquoteselector for now
          t["selector"].each do |s|
            if ! s.nil? && s["type"] == 'TextQuoteSelector'
              target[:TextQuoteSelector] = s
            end
          end
          # we only support a single target for now
          model[:target] = target
        end
      rescue => e
       raise e
      end
      @mapper.map(agent,source,model,FORMAT_OALD)
    end

  end

end

