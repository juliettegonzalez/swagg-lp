class Parameter
    def initialize(name, paramType, dataType, required, description)
        @name = name
        @paramType = paramType
        @dataType = dataType
        @required = required
        @description = description
    end

    def name
        @name
    end

    def paramType
        @paramType
    end

    def dataType
        @dataType
    end

    def required
        @required
    end

    def description
        @description
    end

    def to_s
        "(#{paramType}) #{name} : #{dataType} #{required ? '(required)' : ''}"
    end
end
