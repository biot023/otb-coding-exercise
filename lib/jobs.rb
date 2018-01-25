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
    end

    def <=>(other)
      if dependency && dependency == other.name
        1
      elsif other.dependency && other.dependency == name
        -1
      else
        0
      end
    end

  end

end
