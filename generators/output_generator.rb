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

def generateHTMLPage(output)
    template = Tilt.new('/var/SwaggLP/templates/output.slim')
    return template.render(output, output.to_h)
end
