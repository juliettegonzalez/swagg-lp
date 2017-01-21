require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require 'slim'
require 'colorize'
require 'tilt'

require_relative '../models/endpoint'
require_relative '../models/parameter'
require_relative '../models/response'
require_relative '../models/model'
require_relative '../models/property'

def generate_HTML_page(output)
    template = Tilt.new('/var/SwaggLP/templates/output.slim')
    return template.render(output, output.to_h)
end

def generate_HTML_index(outputs, url)
    template = Tilt.new('/var/SwaggLP/templates/index.slim')
    return template.render(outputs, {
        :error => outputs.select{ |o| o.result.include? "Error"},
        :warning => outputs.select{ |o| o.result.include? "Warning"},
        :success => outputs.select{ |o| o.result.include? "Success"},
        :url => url
        })
end
