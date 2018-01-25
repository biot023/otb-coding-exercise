require './lib/jobs'

describe Jobs::Job do

  def create(desc)
    described_class.new(desc)
  end

  describe "construction" do

    it "can have a name and a dependency" do
      job = create("a => b")
      expect(job.name).to eq("a")
      expect(job.dependency).to eq("b")
    end

    it "can have no dependency" do
      job = create("z =>")
      expect(job.name).to eq("z")
      expect(job.dependency).to be_nil
    end

    it "has to have at least a name and a dependency separator" do
      expect { create("a") }.to raise_error(RuntimeError)
    end

    it "can't depend on itself" do
      expect { create("x => x") }.to raise_error("Jobs can't depend on themselves: \"x => x\"")
    end

  end # /construction

  describe "comparison" do

    it "jobs with no dependency are the same" do
      a = create("z =>")
      b = create("a =>")
      expect(a <=> b).to eq(0)
      expect(b <=> a).to eq(0)
      expect(a <=> a).to eq(0)
    end

    it "jobs with unrelated dependencies are the same" do
      a = create("a => x")
      b = create("b => y")
      c = create("c => z")
      expect(a <=> b).to eq(0)
      expect(a <=> c).to eq(0)
      expect(b <=> a).to eq(0)
      expect(b <=> c).to eq(0)
      expect(c <=> b).to eq(0)
      expect(c <=> a).to eq(0)
    end

    it "a job with no dependency comes before a job with a dependency" do
      a = create("a =>")
      b = create("b => c")
      expect(a <=> b).to eq(-1)
    end

    it "a job with a dependency comes after a job with no dependency" do
      a = create("a => c")
      b = create("b =>")
      expect(a <=> b).to eq(1)
    end

    it "a job comes later than a job it depends on" do
      a = create("a => b")
      b = create("b =>")
      expect(a <=> b).to eq(1)
      expect([a, b].sort).to eq([b, a])
    end

    it "a job comes before a job that depends on it" do
      a = create("a => b")
      b = create("b => c")
      expect(b <=> a).to eq(-1)
    end

    describe "example from acceptance" do
      subject do
        [
          "a =>",
          "b => c",
          "c => f",
          "d => a",
          "e => b",
          "f =>",
        ]
          .map { |desc| create(desc) }
          .sort
          .map(&:name)
      end

      it "contains all the jobs" do
        expect(subject.sort).to eq(["a", "b", "c", "d", "e", "f"])
      end

      [["f", "c"], ["c", "b"], ["b", "e"], ["a", "d"]].each do |(prev_job, next_job)|

        it "sorts #{ prev_job } before #{ next_job }" do
          prev_index = subject.find_index(prev_job)
          next_index = subject.find_index(next_job)
          expect(next_index).to be > prev_index
        end

      end

    end # /example from acceptance

  end # /comparison

end
