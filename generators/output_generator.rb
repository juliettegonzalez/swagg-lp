require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require 'colorize'
require_relative '../models/endpoint'
require_relative '../models/parameter'
require_relative '../models/response'
require_relative '../models/model'
require_relative '../models/property'


def createErrorFile(method, uri, parameter, response)
  directory_name = "/output"
  Dir.mkdir(directory_name) unless File.exists?(directory_name)

  prng = Random.new
  num = prng.rand(10000)

  error_file = File.new("/output/#{response.code}_#{num}.txt", "w")
  #error_file.puts("[#{method}] #{uri} (#{(parameter != nil)? (parameter.map &:to_s) : ""}) : #{response.code} \n #{response.body}")
  error_file.puts("[#{method}] #{uri} \n\n(#{(parameter != nil)? (parameter) : ""})\n\n#{response.code} : #{response.body}")
  error_file.close
  return error_file
end


def generateOutput(method, uri, parameter, response)
    case response.code
    when "200"
        error_file = createErrorFile(method, uri, parameter, response)
        result = "Warning [200]".yellow

    when "401"
        error_file = createErrorFile(method, uri, parameter, response)
        result = "Warning [401]".yellow

    when "406"
        error_file = createErrorFile(method, uri, parameter, response)
        result = "Ok [406]".green

    when "404"
        error_file = createErrorFile(method, uri, parameter, response)
        result = "Warning [404]".yellow

    when "500"
        error_file = createErrorFile(method, uri, parameter, response)
        result = "Error [500]".red

    else
        error_file = createErrorFile(method, uri, parameter, response)
        result = "Error [#{response.code}]".red
    end

    return "#{result}\t\t#{"[#{method}]".green}\t\t\t#{uri}\t\t\t#{"See details \"#{error_file.path}\"".cyan}"
end
