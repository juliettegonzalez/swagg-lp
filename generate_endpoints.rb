require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require_relative 'endpoint'
require_relative 'parameter'
require_relative 'response'
require_relative 'model'
require_relative 'property'


# Excecute requests for one endpoint
def excecute_request(method, url, parameters, response)
  # Full address
  uri = URI.parse(url)   #NB : faut il parser l'URI pour les {id}, etc ?

  if method == 'GET'
    if parameters != nil
      #TODO : generation of the parameters
      parameters = [{ :id => 342342 }, { :id => 44454 }]
      parameters.each do |parameter|
        uri.query = URI.encode_www_form(parameter)
        res = Net::HTTP.get_response(uri)
        puts res.body
      end
    else
      res = Net::HTTP.get_response(uri)
      puts res.body
    end

  elsif method == 'POST'
    if parameters != nil
      parameters = [{ :id => 342342 }, { :id => 44454 }]
      parameters.each do |parameter|
        res = Net::HTTP.post_form(uri, parameter)
        puts res.body
      end
    else
      puts "Erreur"
    end

  elsif method == 'PUT'

  elsif method == 'DELETE'


  end
end


def launch_requests(baseURL, endpoints)
  endpoints.each do |endpoint|
    url = baseURL + endpoint.uri
    #TODO : get the parameters
    parameters = []
    responses = excecute_request(endpoint.method, url, parameters, endpoint.responses)
  end
end


excecute_request('GET', 'http://www.google.com', nil, nil)
