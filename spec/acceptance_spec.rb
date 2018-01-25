require './lib/jobs'

describe Jobs do

  def subject(input)
    Jobs.execution_order(input)
  end

  it "retururns the solitary job" do
    expect(subject("a =>")).to eq("a")
  end

end
