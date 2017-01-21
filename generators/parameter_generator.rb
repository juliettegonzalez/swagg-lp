require 'rubygems'
require 'json'
require 'yaml'
require 'net/http'
require 'uri'
require 'bson'
require_relative '../models/endpoint'
require_relative '../models/parameter'
require_relative '../models/response'
require_relative '../models/model'
require_relative '../models/property'


TYPES = ['nil', 'int', 'float', 'string', 'bool', 'hex', 'array']

def random_int(min: 0, max: 2 << 32)
    return Random.rand(min...max)
end

def random_float(min: 0, max: 2 << 32)
  width = (min-max)
  return (rand*width)+max
end

def random_string(length: 1000)
    return rand(36**length).to_s(36)
end

def random_array(length: 10000)
    result = Array.new(length, 0)
    return result.map { |e| yield }
end

def random_bool
    return random_int(min: 0, max: 1) == 0
end

def random_hex
    BSON::ObjectId.new.to_s
end

def generate_other_types(types)
    type = TYPES - types
    type = type[Random.rand(0...type.length)]
    return generate_type(type)
end

def generate_type(type)
    return nil if type == 'nil'
    return generate_array('string', length: 10) if type == 'array'
    return random_int if type == 'int'
    return random_float if type == 'float'
    return random_string(length: 10) if type == 'string'
    return random_bool if type == 'bool'
    return random_hex if type == 'gopkg.in.mgo.v2.bson.ObjectId' || type == "hex"
end

def generate_array(type, length: 10000)
    return random_array(length: length) { generate_type(type) }
end

def generate_model(model, number: 10)
    if !model.properties || model.properties.length == 0 then
        types = TYPES - [model.id, 'nil', 'array', 'bool']
        return generate_other_types(types)
    end
    res = [0...number].map do |e|
        result = {}
        model.properties.each do |property|
            type = TYPES.clone - [property.type]
            type = type[Random.rand(0...type.length)]
            value = generate_type(type)
            result[property.name] = value if value
        end
        return result
    end
    return res
end

def generate_from_tag(tag, number: 1)
    config = YAML.load_file('/var/SwaggLP/config.yml')
    return nil if !config["tags"].keys.include?(tag)
    script = config["tags"][tag]
    result = `/var/SwaggLP/scripts/#{script}`
    return result.gsub("\n","")
end

def generate_URL(endpoint)
    uri = endpoint.uri.clone
    params = uri.split("/").select do |e| /.*{(.*)}.*/.match(e) end
    params = params.map do |e| /.*{(.*)}.*/.match(e).captures.first end
    endpoint_params = {}
    query_params = {}
    endpoint.params.each do |param|
        endpoint_params[param.name] = param if param.param_type == "path"
        query_params[param.name] = param if param.param_type == "query"
    end
    endpoint_params.keys.each do |param|
        param = endpoint_params[param]
        if param.tag
            value = generate_from_tag(param.tag)
        else
            value = generate_other_types(['nil', 'bool', 'array']).to_s
        end
        uri.gsub!("\{#{param.name}\}", value)
    end

    query_params.keys.each do |param|
        param = query_params[param]
        if param.tag
            value = generate_from_tag(param.tag)
        else
            value = generate_other_type(['nil', 'bool', 'array']).to_s
        end
        uri = "#{uri}&#{param.name}=#{value}" if uri.include? "?"
        uri = "#{uri}?#{param.name}=#{value}" if !uri.include? "?"
    end

    uri
end
