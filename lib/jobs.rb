module Jobs
  def self.execution_order(input)
    input.split("\n").map { |desc| Job.new(desc) }.sort.map(&:name).join(" ")
  end

  class Job
    attr_accessor :name, :dependency
    PATTERN = /^([a-z]) =>( ([a-z]))?$/

    def initialize(desc)
      m = PATTERN.match(desc)
      if m
        @name, @dependency = m[1], m[3]
      else
        raise("Improper Job descriptor #{ desc.inspect }")
      end
      if @dependency == @name
        raise("Jobs can't depend on themselves: #{ desc.inspect }")
      end
    end

    def <=>(other)
      if dependency
        if other.dependency
          if dependency == other.name
            1
          elsif other.dependency == name
            -1
          else
            0
          end
        else
          1
        end
      else
        if other.dependency
          -1
        else
          0
        end
      end
    end

  end

end
