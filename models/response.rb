class Response
    def initialize(code, responseType, responseModel)
        @code = code
        @responseType = responseType
        @responseModel = responseModel
    end

    def code
        @code
    end

    def response_type
        @responseType
    end

    def response_model
        @responseModel
    end

    def to_s
        "#{code} : (#{responseType}) #{responseModel}"
    end
end
