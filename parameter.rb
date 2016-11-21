class Parameter
    def initialize(name, paramType, dataType, required)
        @name = name
        @paramType = paramType
        @dataType = dataType
        @required = required
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

    def to_s
        "#{paramType} #{name} : #{dataType} (#{required})"
    end
end
