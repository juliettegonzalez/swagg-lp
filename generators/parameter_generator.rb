require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'bson'
require_relative '../models/endpoint'
require_relative '../models/parameter'
require_relative '../models/response'
require_relative '../models/model'
require_relative '../models/property'


TYPES = ['nil', 'int', 'float', 'string', 'bool', 'hex', 'array']

def randomInt(min: 0, max: 2 << 32)
    return Random.rand(min...max)
end

def randomFloat(min: 0, max: 2 << 32)
  width = (min-max)
  return (rand*width)+max
end

def randomString(length: 1000)
    return rand(36**length).to_s(36)
end

def randomArray(length: 10000)
    result = Array.new(length, 0)
    return result.map { |e| yield }
end

def randomBool()
    return randomInt(min: 0, max: 1) == 0
end

def randomHex()
    BSON::ObjectId.new.to_s
end

def generateOtherType(types)
    type = TYPES - types
    type = type[Random.rand(0...type.length)]
    return generateType(type)
end

def generateType(type)
    return nil if type == 'nil'
    return generateArray('string', length: 10) if type == 'array'
    return randomInt if type == 'int'
    return randomFloat if type == 'float'
    return randomString(length: 10) if type == 'string'
    return randomBool if type == 'bool'
    return randomHex if type == 'gopkg.in.mgo.v2.bson.ObjectId'
end

def generateArray(type, length: 10000)
    return randomArray(length: length) { generateType(type) }
end

def generateModel(model, number: 10)
    if !model.properties || model.properties.length == 0 then
        types = TYPES - [model.id, 'nil', 'array', 'bool']
        return generateOtherType(types)
    end
    res = [0...number].map do |e|
        result = {}
        model.properties.each do |property|
            type = TYPES.clone - [property.type]
            type = type[Random.rand(0...type.length)]
            value = generateType(type)
            result[property.name] = value if value
        end
        return result
    end
    return res
end

def generateURL(endpoint)
    uri = endpoint.uri
    params = uri.split("/").select do |e| /.*{(.*)}.*/.match(e) end
    params = params.map do |e| /.*{(.*)}.*/.match(e).captures.first end
    endpointParams = {}
    endpoint.params.each do |param|
        endpointParams[param.name] = param.dataType if param.paramType == "path"
    end
    params.each do |param|
        value = generateOtherType([endpointParams[param], 'nil', 'bool', 'array']).to_s
        uri.gsub!("\{#{param}\}", value)
    end
    uri
end
