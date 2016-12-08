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



def analyseResponse(code)
  case code
  when "200"
    return "Warning : Returned code 200 but was expecting an error"
  when "406"
    return "Ok : Returned code 406"
  when "404"
    return "Error : Returned code 404 (not found)"
  when "500"
    return "Error : Returned code 500 (internal error)"
  else
    return "Unknow error"
  end
end


def generateOutput(method, uri, parameter, response)
  return "[#{method}] #{uri} (#{parameter.map &:to_s}) : \"#{analyseResponse(response.code)}\""
end
