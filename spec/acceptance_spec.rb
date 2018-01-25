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

  it "observes more complex dependencies" do
    ordered_jobs = subject(
      [
        "a =>",
        "b => c",
        "c => f",
        "d => a",
        "e => b",
        "f =>",
      ]
        .join("\n")
    )
      .split(" ")
    expect(ordered_jobs.sort.join(" ")).to eq("a b c d e f")
    [["f", "c"], ["c", "b"], ["b", "e"], ["a", "d"]].each do |(prev_job, next_job)|
      prev_index = ordered_jobs.find_index(prev_job)
      next_index = ordered_jobs.find_index(next_job)
      expect(next_index).to be > prev_index
    end
  end

end
