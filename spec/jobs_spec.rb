require './lib/jobs'

describe Jobs do
  describe ".execution_order(input)" do
    def subject(input)
      Jobs.execution_order(input)
    end

    it "returns a single job" do
      expect(subject("a =>")).to eq("a")
    end

    it "returns in first-in order if no dependencies" do
      expect(subject("a =>\nb =>\nc =>")).to eq("a b c")
      expect(subject("c =>\nb =>\na =>")).to eq("c b a")
      expect(subject("c =>\na =>\nb =>")).to eq("c a b")
    end

    it "returns first-in order and order specified by dependency" do
      expect(subject("a =>\nb => c\nc =>")).to eq("a c b")
    end

    it "can't have circular dependencies" do
      expect { subject("a => b\nb => c\nc => a") }
        .to raise_error("Jobs can't have circular dependencies")
    end
  end # /.execution_order(input)
end
