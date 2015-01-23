require 'json'
require 'uri'

module HypothesisApi

  class Client

    def initialize(mapper)
      @mapper = mapper
    end

    def get(uri)
      respobj = {}
      begin
        uri = URI.parse(uri)
        response = Net::HTTP.start(uri.host, uri.port) do |http|
          http.send_request('GET',uri.request_uri)
        end
        if (response.code == '200') 
          transform_data(response.body)
        else
          respobj = { :is_error  => true,
                      :error => "HTTP #{response.code}" }
        end
      rescue Exception => e
        respobj = { :is_error  => true,
                    :error => e }
      end
      respobj
    end

    def transform_data(source,data)
      model = {}
      begin
        orig_annot = JSON.parse(data)
        Rails.logger.info(orig_annot.inspect)
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
        model[:targets] = []
        orig_annot["target"].each do |t|
          target = {} 
          target[:uri] = t["source"]
          target[:selectors] = {}
          t["selector"].each do |s|
            target[:selectors][s.type] = s
          end
          model[:targets] << target
        end
        Rails.logger.info(model.inspect)
      rescue Exception => e
         raise e
      end
      @mapper.map(model)
    end

  end

end

