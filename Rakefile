require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "csv"
require "fileutils"
require_relative "lib/hypothesis-client"
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc "Run a test transformation of a list of annotations"
task :transform, [:filename, :outputdir] do |t,args|
    client = HypothesisClient::Client.new(HypothesisClient::MapperPrototype::JOTH.new)
    output = []
    CSV.foreach(args[:filename], :headers => false) do |row|
      f = row[0]
      user = row[1]
      path = f.split /\//
      uuid = "pdljann.#{path.last}.1.1"
      data = client.get(f, "urn:cite:perseus:#{uuid}", user)
      output << { 'objid' => path.last, 'path' => "#{uuid}.json", 'file' => f, 'data' => data }
    end
    output.each do |a|
      FileUtils::mkdir_p File.join(args[:outputdir],a['objid'])
      output = File.open(File.join(args[:outputdir],a['objid'],a['path']),'w+')
      output << JSON.pretty_generate(a['data'])
      output.close
    end
end

# additional transformation for tufts myth 2015
# 1. these annotations refer to other hypothes.is annotations
#    and so need the urls replaced with the urls for the Perseids
#    converted annotations
# 2. Person identification annotations were done in separate step 
#    from the the annotation of the bond relationships, and so we 
#    need to lookup the person identifier from the annotation which 
#    captured that and replace the use of the text of the name
# 3. groups used a shared account for annotating and so we need
#    to  add the group members to the annotation
#
# Inputs to the task are 
#   filename - list of paths to the annotations to update
#   grouplist - list of sosol user ids and cooresponding group members 
task :transformformyth, [:filename, :grouplist, :outputdir] do |t, args|
  groups = {}
   
  CSV.foreach(args[:grouplist], :headers => false) do |row|
    group = row[0].strip
    member = row[1].strip
    unless groups[group]
      groups[group] = []
    end
    groups[group] << member
  end

  first = []
  mapping = {}
  hyp = {}
  names = {}
  CSV.foreach(args[:filename], :headers => false) do |row|
    f = row[0]
    path = f.split /\//
    uuid = "#{path.last}"
    data = ""
    File.open(f,"r") do |infile|
      while (line = infile.gets)
        data = data + "#{line}" 
      end
    end 
    data = JSON.parse(data)
    if (data["error"]) 
      puts "ERROR: #{f}"
      next
    end
    unless (data["data"]["annotatedBy"]) 
      puts "ERROR: No Annotator #{f}"
      next
    end
    first << { 'path' => f, 'uuid' => uuid, 'file' => f, 'data' => data["data"] }
    hyp[data["data"]["dcterms:source"].sub('https://hypothes.is/api/annotations/', '')] = "http://data.perseus.org/collections/urn:cite:perseus:#{uuid.sub(/\.json$/,'')}"
    if data["data"]['dcterms:title'] =~ /as person/ 
      source = data["data"]["hasTarget"]["hasSource"]['@id']
      selector = data["data"]["hasTarget"]["hasSelector"]
      nametext ="#{selector["prefix"]}-#{selector["exact"]}-#{selector["suffix"]}"
      #puts "f #{f} Source #{source} selector #{selector.inspect} nametext #{nametext}"
      unless mapping[source]
        mapping[source] = {}
      end
      unless names[source]
        names[source] = {}
      end
      unless names[source][selector['exact']]
        names[source][selector['exact']] = []
      end
      mapping[source][nametext] = data["data"]["hasBody"][0]['@id']
      names[source][selector['exact']] << data["data"]["hasBody"][0]['@id']
    end
  end


  first.each do |a|
    FileUtils::mkdir_p File.join(args[:outputdir],a['path'].sub(/\/#{a['uuid']}/,''))
    output = File.open(File.join(args[:outputdir],a['path']),'w')
    a['data']['annotatedBy']['@type'] = 'foaf:Group'
    a['data']['annotatedBy']['foaf:member'] = []
    unless groups[a['data']['annotatedBy']['@id']]
       puts "ERROR: No Group for #{a['data']['annotatedBy']['@id']}"
       next
    end
    groups[a['data']['annotatedBy']['@id']].each do |m|
       a['data']['annotatedBy']['foaf:member'] << { 'foaf:name' => m, '@type' => 'foaf:person' }
    end
    if (a['data']['dcterms:title'] =~ /snap:/)
      source = a['data']["hasTarget"]["hasSource"]['@id']
      selector = a['data']["hasTarget"]["hasSelector"]
      selector['exact'].strip!
      selector['prefix'].strip!
      selector['suffix'].strip!
      nametext ="#{selector["prefix"]}-#{selector["exact"]}-#{selector["suffix"]}"
      person = mapping[source][nametext]
      if person.nil? 
        if names[source][selector['exact']].nil?
          person = selector['exact']
         else
          person = names[source][selector['exact']][0]
         end
      end
      a['data']['hasBody']['@graph'][2]['snap:bond-with']['@id'] = person
    elsif a['data']['dcterms:title'] =~ /is linked to/ && a['data']['hasBody']['@graph'][0]['@id'] =~ /https:\/\/hypothes.is/
      source =  a['data']['hasBody']['@graph'][0]['@id'].sub!('https://hypothes.is/a/','')
      a['data']['hasBody']['@graph'][0]['@id'] = hyp[source]
    end
    output << JSON.pretty_generate(a['data'])
    output.close
  end

end


