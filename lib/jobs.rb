module Jobs

  def self.execution_order(input)
    ExecutionOrderGenerator.new.generate_from(input)
  end

  class ExecutionOrderGenerator

    def generate_from(input)
      output_in_execution_order(
        ensure_no_circular_dependencies(
          generate_jobs(input)
        )
      )
    end

    private

    def generate_jobs(input)
      input.split("\n").map { |desc| Job.new(desc) }
    end

    def ensure_no_circular_dependencies(jobs)
      jobs.each do |origin|
        job, count = origin, 0
        while job.dependency
          raise("Jobs can't have circular dependencies") if count == jobs.size
          job = jobs.find { |other| other.name == job.dependency }
          count += 1
        end
      end
      jobs
    end

    def output_in_execution_order(jobs)
      jobs.sort.map(&:name).join(" ")
    end

  end

  class Job
    attr_reader :name, :dependency
    PATTERN = /^([a-z]) =>( ([a-z]))?$/

    def initialize(desc)
      m = PATTERN.match(desc)
      if m
        @name, @dependency = m[1], m[3]
      else
        raise("Improper Job descriptor #{ desc.inspect }")
      end
      raise("Jobs can't depend on themselves: #{ desc.inspect }") if @dependency == @name
    end

    def <=>(other)
      dep_a, dep_b = dependency, other.dependency
      case [!!dep_a, !!dep_b]
      when [false, false]
        0
      when [true, false]
        1
      when [false, true]
        -1
      when [true, true]
        if dep_a == other.name
          1
        elsif dep_b == name
          -1
        else
          0
        end
      end
    end

  end

end
