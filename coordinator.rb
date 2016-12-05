require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require_relative 'models/endpoint'
require_relative 'models/parameter'
require_relative 'models/response'
require_relative 'models/model'
require_relative 'models/property'
require_relative 'generators/parser'
require_relative 'generators/endpoints_generator'
require_relative 'generators/parameter_generator'


baseURL, endpoints, models = parse('/tmp/user/index.json')
