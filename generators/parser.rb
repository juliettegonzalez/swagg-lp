require 'rubygems'
require 'json'
require_relative '../models/endpoint'
require_relative '../models/parameter'
require_relative '../models/response'
require_relative '../models/model'
require_relative '../models/property'


def read_file(path)
  content = ""
  file = File.new(path, "r")
  while (line = file.gets)
      content += "#{line}\n"
  end
  file.close
  JSON.parse content
end

# Endpoints
def get_endpoints(json)
  endpoints = []
  json['apis'].each do |api|
    api['operations'].each do |operation|
      params = []
      responses = []
      operation['parameters'].each do |parameter|
        params << Parameter.new(parameter['name'], parameter['paramType'], parameter['dataType'], parameter['required'])
      end
      operation['responseMessages'].each do |response|
        responses << Response.new(response['code'], response['responseType'], response['responseModel'])
      end
      endpoints << Endpoint.new(api['path'], operation['httpMethod'], params, responses)
    end
  end
  endpoints
end

#Models
def get_models(json)
  models = {}
  json['models'].each do |key, value|
    properties = []
    if value['properties'] != nil
      value['properties'].each do |key, value|
        properties << Property.new(key, value['type'])
      end
    end
    models[value['id']] = Model.new(value['id'], properties)
  end
  models
end


#Global file
def parse(path)
  json = read_file path
  baseURL = json['basePath']
  endpoints = get_endpoints json
  models = get_models json
  return baseURL, endpoints, models
end
