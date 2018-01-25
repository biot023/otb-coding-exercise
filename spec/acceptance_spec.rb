require './lib/jobs'

describe "Acceptance tests" do

  def subject(input)
    Jobs.execution_order(input)
  end

  it "returns the solitary job" do
    expect(subject("a =>")).to eq("a")
  end

  it "returns a list of unordered jobs" do
    ordered_jobs = subject("a =>\nb =>\nc =>").split(" ")
    expect(ordered_jobs.sort).to eq(["a", "b", "c"])
  end

  xit "returns jobs with a specified order" do
  end

end
