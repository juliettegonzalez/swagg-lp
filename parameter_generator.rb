require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'bson'
require_relative 'endpoint'
require_relative 'parameter'
require_relative 'response'
require_relative 'model'
require_relative 'property'


TYPES = ['Int', 'Float', 'String', 'Hex', 'Array']

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

def randomHex()
    BSON::ObjectId.new.to_s
end

def generateType(type)
    functions = [Proc.new {randomInt}, Proc.new {randomFloat}, Proc.new {randomString}, Proc.new {randomHex}]
    return Proc.new {functions[TYPES.index(type)]}.call
end

def generateArray(type)
    functions = [Proc.new {randomInt}, Proc.new {randomFloat}, Proc.new {randomString}, Proc.new {randomHex}]
    return Proc.new { randomArray { functions[TYPES.index(type)].call } }.call
end

def generateModel(model)
    
end
