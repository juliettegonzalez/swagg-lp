require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require_relative '../models/endpoint'
require_relative '../models/parameter'
require_relative '../models/response'
require_relative '../models/model'
require_relative '../models/property'

def generate_request(method, url, parameters)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  request = nil
  if method == 'GET'
      request = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
  elsif method == 'POST'
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
  elsif method == 'PUT'
    request = Net::HTTP::Put.new(uri.path, 'Content-Type' => 'application/json')
  elsif method == 'DELETE'
    request = Net::HTTP::Delete.new(uri.path, 'Content-Type' => 'application/json')
  end
  request.body = parameters.to_json if parameters
  return http, request
end


def excecute_request(method, url, parameter)
    result = `curl -w "%{http_code}" -s -H \"Content-Type: application/json\" -X #{method} -d '#{parameter}' #{url}`
    body = result.clone
    code = result.to_s.encode('UTF-8', :invalid => :replace).split("\n").last.gsub("\n", "").gsub(/[A-Za-z]/, '')
    return {"body" => body.to_s, "code" => code}
end
