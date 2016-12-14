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


def createErrorFile(method, uri, parameter, response)
  directory_name = "errorsLogs"
  Dir.mkdir(directory_name) unless File.exists?(directory_name)

  prng = Random.new
  num = prng.rand(10000)

  error_file = File.new("errorsLogs/#{response.code}_#{num}.txt", "w")
  error_file.puts("[#{method}] #{uri} (#{(parameter != nil)? (parameter.map &:to_s) : ""}) : #{response.code} \n #{response.body}")
  error_file.close
  return error_file
end


def generateOutput(method, uri, parameter, response)
  case response.code
  when "200"
    error_file = createErrorFile(method, uri, parameter, response)
    result = "Warning [200] See details \"#{error_file.path}\""

  when "406"
    result = "Ok [406]"

  when "404"
    error_file = createErrorFile(method, uri, parameter, response)
    result = "Error [404] See details \"#{error_file.path}\""

  when "500"
    error_file = createErrorFile(method, uri, parameter, response)
    result = "Error [500] See details \"#{error_file.path}\""

  else
    error_file = createErrorFile(method, uri, parameter, response)
    result = "Unknow error"
  end

  return "#{result} : [#{method}] #{uri}"
end
