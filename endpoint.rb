class Endpoint
    def initialize(uri, method, params, responses)
        @uri = uri
        @method = method
        @params = params
        @responses = responses
    end

    def uri
        @uri
    end

    def method
        @method
    end

    def params
        @params
    end

    def responses
        @responses
    end

    def to_s
        "[#{method}] #{uri} (#{params.map &:to_s}) : #{responses.map &:to_s}"
    end
end
