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
        config = YAML.load_file('/var/SwaggLP/config.yml')
        warning = []
        error = []
        success = []
        warning = config["codes"]["warning"] if config["codes"]["warning"]
        error = config["codes"]["error"] if config["codes"]["error"]
        success = config["codes"]["success"] if config["codes"]["success"]
        result = "Error"
        if response != :timeout then
            if error.include? response["code"].to_i then
                result = "Error"
            elsif warning.include? response["code"].to_i then
                result = "Warning"
            elsif success.include? response["code"].to_i then
                result = "Success"
            end
            result += " [#{response["code"]}]"
        else
            result = "Error"
            result += " [TIMEOUT]"
        end

        @uri = uri
        @method = method
        @parameters = JSON.pretty_generate(parameters)
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

    def status
        @result.split(" ").first.downcase
    end

    def colorized_result
        if self.result.include? "Success" then
            return self.result.green
        elsif self.result.include? "Error" then
            return self.result.red
        else
            return self.result.yellow
        end
    end

    def sum_up(folder)
        config = YAML.load_file('/var/SwaggLP/config.yml')
        url = config["log_server"]["url"]
        log_file = "#{url}/#{folder}/#{self.id}.html"
        return "#{self.colorized_result}\t\t#{"[#{self.method}]".green}\t\t\t#{self.uri}\t\t\t#{"See details \"#{log_file}\"".cyan}"
    end

    def to_h
        return {
            "result" => self.result,
            "id" => self.id,
            "parameters" => self.parameters,
            #"code" => (self.response != :timeout ? self.response.code : "Timeout"),
            #"message" => (self.response != :timeout ? self.response.message : "Timeout"),
            #"body" => (self.response != :timeout ? self.response.body : "Timeout"),
            "code" => self.response["code"],
            "message" => "------",
            "body" => self.response["body"],
            "uri" => self.uri,
            "method" => self.method
        }
    end

    def render(local) #FIX a bug in template generation
        return local
    end

end
