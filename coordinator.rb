require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require 'colorize'

require_relative 'models/endpoint'
require_relative 'models/parameter'
require_relative 'models/response'
require_relative 'models/model'
require_relative 'models/property'

require_relative 'generators/parser'
require_relative 'generators/endpoints_generator'
require_relative 'generators/parameter_generator'
require_relative 'generators/output_generator'

def treatEndpoint(endpoint, baseURL, models, out_file)
    url = generateURL(endpoint)
    params = []
    endpoint.params.each do |param|
        if param.paramType == "body" then
          if param.hasParamTag then
            params << generateFromTag(param.paramTag, number: 10)
          else
            params << generateModel(models[param.dataType])
          end
        end
    end

    limit = 0
    limit = params.map { |e| e.length }.min if params.length > 0

    if limit == 0 then
        http, request = generateRequest(endpoint.method, baseURL + url, nil)
        res = http.request(request)
        output = generateOutput(endpoint.method, url, [], res)
        puts output
    else
        for i in 0...limit do
            paramsToSend = params
            #paramsToSend = params.map { |e| e[i] } if params.length > 0
            http, request = generateRequest(endpoint.method, baseURL + url, paramsToSend)
            res = http.request(request)
            output = generateOutput(endpoint.method, url, paramsToSend, res)
            #puts paramsToSend
            puts output
            #out_file.puts(output)
        end
    end

end

baseURL, endpoints, models = parse('/tmp/user/index.json')
out_file = File.new("output.txt", "w")
endpoints.each { |endpoint|
    (0..10).each { |e|
        treatEndpoint(endpoint, baseURL, models, out_file)
    }
    puts ""
}
#
# baseURL, endpoints, models = parse('/tmp/search/index.json')
# out_file = File.new("output.txt", "w")
# endpoints.each { |endpoint| [0...3].each { |e| treatEndpoint(endpoint, baseURL, models, out_file) }}
#
# baseURL, endpoints, models = parse('/tmp/report/index.json')
# out_file = File.new("output.txt", "w")
# endpoints.each { |endpoint| [0...3].each { |e| treatEndpoint(endpoint, baseURL, models, out_file) }}
#
out_file.close
puts "finished"
