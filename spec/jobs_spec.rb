require './lib/jobs'

describe Jobs do
  describe ".execution_order(input)" do
    def subject(input)
      Jobs.execution_order(input)
    end

    it "returns a single job" do
      expect(subject("a =>")).to eq("a")
    end

    it "returns in first-in order if no specified order" do
      expect(subject("a =>\nb =>\nc =>")).to eq("a b c")
      expect(subject("c =>\nb =>\na =>")).to eq("c b a")
      expect(subject("c =>\na =>\nb =>")).to eq("c a b")
    end

    it "returns first-in order and specified order" do
      expect(subject("a =>\nb => c\nc =>")).to eq("a c b")
    end
  end # /.execution_order(input)
end
