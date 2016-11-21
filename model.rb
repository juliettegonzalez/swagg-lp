class Model
    def initialize(id, properties)
        @id = id
        @properties = properties
    end

    def id
        @id
    end

    def properties
        @properties
    end

    def to_s
        "#{id}"
    end
end
