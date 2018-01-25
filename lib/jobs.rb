module Jobs
  def self.execution_order(input)
    input.split("\n").map { |job| job.gsub(/[^a-z]/, '') }.join(" ")
  end
end
