require './lib/jobs'

describe Jobs do

  def subject(input)
    Jobs.execution_order(input)
  end

  it "returns the solitary job" do
    expect(subject("a =>")).to eq("a")
  end

  it "returns a list of unordered jobs" do
    expect(subject("a =>\nb =>\nc =>")).to eq("a b c")
  end

end
