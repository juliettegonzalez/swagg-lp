class Property
    def initialize(name, type)
        @name = name
        @type = type
    end

    def name
        @name
    end

    def type
        @type
    end

    def to_s
        "#{name} : #{type}"
    end
end
