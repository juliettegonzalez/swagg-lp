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

def treat_endpoint(endpoint, baseURL, models)
    result = []
    url = generate_URL(endpoint)
    params = []
    endpoint.params.each do |param|
        if param.param_type == "body" then
          if param.tag then
            params << generate_from_tag(param.tag, number: 10)
          else
            params << generate_model(models[param.data_type])
          end
        end
    end

    limit = 0
    limit = params.map { |e| e.length }.min if params.length > 0

    if limit == 0 then
        http, request = generate_request(endpoint.method, baseURL + url, nil)
        begin
            #res = http.request(request)
            #puts "Sending request on #{baseURL+url} => #{res.body}"
            res = excecute_request(endpoint.method, baseURL + url, {})
            result << Output.new(endpoint.method, url, [], res)
        rescue => e
            puts e
            result << Output.new(endpoint.method, url, [], :timeout)
        end
    else
        for i in 0...limit do
            params_to_send = params
            #paramsToSend = params.map { |e| e[i] } if params.length > 0
            excecute_request(endpoint.method, baseURL + url, params_to_send)
            http, request = generate_request(endpoint.method, baseURL + url, params_to_send)
            begin
                #res = http.request(request)
                #puts request
                #puts "Sending request on #{baseURL+url} => #{res.body}"
                res = excecute_request(endpoint.method, baseURL + url, {})
                result << Output.new(endpoint.method, url, params_to_send, res)
            rescue => e
                puts e
                result << Output.new(endpoint.method, url, [], :timeout)
            end
        end
    end
    return result
end

results = []
puts "Running Fuzzy Test"
config = YAML.load_file('/var/SwaggLP/config.yml')
docs = config["docs"]

for file in docs do
    file = "/tmp/#{file}"
    puts "Testing #{file}..."
    baseURL, endpoints, models = parse(file)
    progress = 0
    total = endpoints.length * 10
    endpoints.each { |endpoint|
        (1..10).each { |e|
            results += treat_endpoint(endpoint, baseURL, models)
            progress += 1
            puts "[Progress] #{((progress.to_f/total.to_f)*100).to_i} %"
        }
    }
end

exit_code = 0
folder = Time.new.strftime("%y.%m.%d_%H-%M-%S").to_s
`mkdir -p ./output/#{folder}`
for result in results do
    File.open("./output/#{folder}/#{result.id}.html", 'w') { |file| file.write(generate_HTML_page(result)) }
    exit_code = 1 if result.status == "error" && exit_code == 0
    puts result.sum_up(folder)
end

url = config["log_server"]["url"]
url = "#{url}/#{folder}/"
File.open("./output/#{folder}/index.html", 'w') { |file| file.write(generate_HTML_index(results, url)) }

File.open("./output/#{folder}/output.json", 'w') { |file| file.write(results.map { |e| e.to_h }.to_json.encode('UTF-8', :invalid => :replace)) }
puts "Finished Fuzzy Test"
exit exit_code
