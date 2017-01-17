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
require_relative 'models/output'

require_relative 'generators/parser'
require_relative 'generators/endpoints_generator'
require_relative 'generators/parameter_generator'
require_relative 'generators/output_generator'

def treatEndpoint(endpoint, baseURL, models)
    result = []
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
        begin
            res = http.request(request)
            result << Output.new(endpoint.method, url, [], res)
        rescue
            result << Output.new(endpoint.method, url, [], :timeout)
        end
    else
        for i in 0...limit do
            paramsToSend = params
            #paramsToSend = params.map { |e| e[i] } if params.length > 0
            http, request = generateRequest(endpoint.method, baseURL + url, paramsToSend)
            begin
                res = http.request(request)
                result << Output.new(endpoint.method, url, paramsToSend, res)
            rescue
                result << Output.new(endpoint.method, url, [], :timeout)
            end
        end
    end
    return result
end

results = []
puts "Running Fuzzy Test"
for file in ['/tmp/user/index.json'] do #, '/tmp/association/index.json', '/tmp/event/index.json', '/tmp/post/index.json', '/tmp/report/index.json', '/tmp/search/index.json', '/tmp/notification/index.json'] do
    puts "Testing #{file}..."
    baseURL, endpoints, models = parse(file)
    progress = 0
    total = endpoints.length * 10
    endpoints.each { |endpoint|
        (1..10).each { |e|
            results += treatEndpoint(endpoint, baseURL, models)
            progress += 1
            puts "[Progress] #{((progress.to_f/total.to_f)*100).to_i} %"
        }
    }
end

folder = Time.new.strftime("%y.%m.%d_%H-%M-%S").to_s
`mkdir -p ./output/#{folder}`
for result in results do
    File.open("./output/#{folder}/#{result.id}.html", 'w') { |file| file.write(generateHTMLPage(result)) }
    puts result.sum_up(folder)
end

config = YAML.load_file('/var/SwaggLP/config.yml')
url = config["log_server"]["url"]
url = "#{url}/#{folder}/"
File.open("./output/#{folder}/index.html", 'w') { |file| file.write(generateHTMLIndex(results, url)) }

File.open("./output/#{folder}/output.json", 'w') { |file| file.write(results.map { |e| e.to_h }.to_json) }
puts "Finished Fuzzy Test"
