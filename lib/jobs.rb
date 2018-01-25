module Jobs
  def self.execution_order(input)
    input.gsub(/[^a-z]/, '')
  end
end
