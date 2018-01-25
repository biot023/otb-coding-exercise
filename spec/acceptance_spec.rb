require './lib/jobs'

describe "Acceptance tests" do

  def subject(input)
    Jobs.execution_order(input)
  end

  it "returns the solitary job" do
    expect(subject("a =>")).to eq("a")
  end

  it "returns a list of unordered jobs when there are no dependencies" do
    ordered_jobs = subject("a =>\nb =>\nc =>").split(" ")
    expect(ordered_jobs.sort).to eq(["a", "b", "c"])
  end

  it "observes a simple dependency when ordering jobs" do
    ordered_jobs = subject("a =>\nb => c\nc =>").split(" ")
    expect(ordered_jobs.size).to eq(3)
    expect(ordered_jobs).to include("a")
    index_of_b = ordered_jobs.find_index("b")
    index_of_c = ordered_jobs.find_index("c")
    expect(index_of_b).to eq(index_of_c + 1)
  end

  xit "observes more complex dependencies" do
  end

end
