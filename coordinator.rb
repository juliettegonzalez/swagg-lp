require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'

require_relative 'models/endpoint'
require_relative 'models/parameter'
require_relative 'models/response'
require_relative 'models/model'
require_relative 'models/property'

require_relative 'generators/parser'
require_relative 'generators/endpoints_generator'
require_relative 'generators/parameter_generator'


baseURL, endpoints, models = parse('/tmp/user/index.json')

endpoint = endpoints.first

url = generateURL(endpoint)
params = []
endpoint.params.each do |param|
    if param.paramType == "body" then
        params << generateModel(models[dataType])
    end
end

limit = 0
limit = params.map { |e| e.length }.min if params.length > 0

if limit == 0 then
    http, request = generateRequest(endpoint.method, baseURL + url, nil)
    res = http.request(request)
    puts res.body
else
    for i in 0...limit do
        parmsToSend = nil
        parmsToSend = params.map { |e| e[i] } if params.length > 0
        http, request = generateRequest(endpoint.method, url, paramsToSend)
        res = http.request(request)
        puts res.body
    end
end

puts "finished"
