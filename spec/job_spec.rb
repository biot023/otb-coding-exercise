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

    describe "examples from acceptance" do

      it "sorts by first in and on dependency" do
        jobs = [
          create("a =>"),
          create("b => c"),
          create("c => f"),
          create("d => a"),
          create("e => b"),
          create("f =>"),
        ]
        expect(jobs.sort.map(&:name)).to eq(["a", "f", "c", "b", "d", "e"])
      end

    end

  end # /comparison

end
