require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require_relative 'endpoint'
require_relative 'parameter'
require_relative 'response'
require_relative 'model'
require_relative 'property'


def excecute_request(method, url, parameter, response)
  # Full address
  uri = URI.parse(url)   #NB : faut il parser l'URI pour les {id}, etc ?
  parameter = { :id => 342342 }

  http = Net::HTTP.new(uri.host, uri.port)

  # https
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  if method == 'GET'
    puts 'GET'
    if parameter != nil
      uri.query = URI.encode_www_form(parameter)
    end
    request = Net::HTTP::Get.new(uri)

  elsif method == 'POST'
    puts 'POST'
    request = Net::HTTP::Post.new(uri)
    if parameter != nil
      request.set_form_data(parameter)
    end

  elsif method == 'PUT'
    puts 'PUT'
    request = Net::HTTP::Put.new(uri.path)
    if parameter != nil
      request.set_form_data(parameter)
    end

  elsif method == 'DELETE'
    puts 'DELETE'
    request = Net::HTTP::Delete.new(uri.path)
    if parameter != nil
      request.set_form_data(parameter)
    end
  end

  res = http.request(request)
  puts res.body
end



def launch_requests(baseURL, endpoints)
  endpoints.each do |endpoint|
    url = baseURL + endpoint.uri
    #TODO : get the parameters
    parameters = []
    parameters.each do |parameter|
      responses = excecute_request(endpoint.method, url, parameter, endpoint.responses)
    end
  end
end


excecute_request('GET', 'https://httpbin.org/get', nil, nil)
excecute_request('POST', 'https://httpbin.org/post', nil, nil)
excecute_request('PUT', 'https://httpbin.org/put', nil, nil)
excecute_request('DELETE', 'https://httpbin.org/delete', nil, nil)
