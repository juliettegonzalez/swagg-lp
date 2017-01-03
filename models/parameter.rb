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

    def hasParamTag
        return @description != nil ? (@description.include? "#") : false
    end

    #NB: we consider that there can be only one tag
    def paramTag
        return @description.split('#')[1].split(' ').first if self.hasParamTag
        return nil
    end

    def to_s
        "(#{paramType}) #{name} : #{dataType} #{required ? '(required)' : ''}"
    end
end
