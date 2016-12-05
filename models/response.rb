class Response
    def initialize(code, responseType, responseModel)
        @code = code
        @responseType = responseType
        @responseModel = responseModel
    end

    def code
        @code
    end

    def responseType
        @responseType
    end

    def responseModel
        @responseModel
    end

    def to_s
        "#{code} : (#{responseType}) #{responseModel}"
    end
end
