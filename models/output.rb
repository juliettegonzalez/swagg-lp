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


class Output

    def initialize(method, uri, parameters, response)
        case response.code
        when "200"
            result = "Warning [200]"
        when "401"
            result = "Warning [401]"
        when "406"
            result = "Ok [406]"
        when "404"
            result = "Warning [404]"
        when "500"
            result = "Error [500]"
        else
            result = "Error [#{response.code}]"
        end
        @uri = uri
        @method = method
        @parameters = parameters
        @response = response
        @result = result
        @id = rand(1000000)
    end

    def uri
        @uri
    end

    def method
        @method
    end

    def parameters
        @parameters
    end

    def response
        @response
    end

    def id
        @id
    end

    def result
        @result
    end

    def colorized_result
        if self.result.include? "Ok" then
            return self.result.green
        elsif self.result.include? "Error" then
            return self.result.red
        else
            return self.result.yellow
        end
    end

    def sum_up
        config = YAML.load_file('/var/SwaggLP/config.yml')
        port = config["logserver"]["port"]
        log_file = "http://localhost:#{port}/#{self.id}.html"
        return "#{self.colorized_result}\t\t#{"[#{self.method}]".green}\t\t\t#{self.uri}\t\t\t#{"See details \"#{log_file}\"".cyan}"
    end

    def to_h
        return {
            "result" => self.result,
            "id" => self.id,
            "parameters" => self.parameters,
            "code" => self.response.code,
            "message" => self.response.message,
            "uri" => self.uri,
            "method" => self.method
        }
    end

    def render(local) #FIX a bug in template generation
        return local
    end

end
