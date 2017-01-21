class Parameter
    def initialize(name, paramType, dataType, required, description)
        @name = name
        @param_type = paramType
        @data_type = dataType
        @required = required
        @description = description
    end

    def name
        @name
    end

    def param_type
        @param_type
    end

    def data_type
        @data_type
    end

    def required
        @required
    end

    def description
        @description
    end

    def has_tag
        return @description != nil ? (@description.include? "#") : false
    end

    def tag
        return @description.split('#')[1].split(' ').first if self.has_tag
        return nil
    end

    def to_s
        "(#{param_type}) #{name} : #{data_type} #{required ? '(required)' : ''}"
    end
end
