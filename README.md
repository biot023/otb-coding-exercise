# On The Beach Technical Test #

## Setup ##

    $ bundle install

## Running the acceptance tests ##

    $ bundle exec rspec spec/acceptance_spec.rb -fd

## Running the acceptance tests with the unit tests ##

    $ bundle exec rspec -fd

## Notes ##

The brief is encapsulated in the file `./spec/acceptance_spec.rb`. I generated additional RSpec
test files under the `./spec` directory as I went through the brief.

All the code to satisy all of the tests is contained in the file `./lib/jobs.rb`.

I started with a module with a single method (`Jobs::execution_order(input)`) and worked in a
canonical TDD way by only satisfying the test immediately in front of me. As additional tests
occurred to me I added them in as unit tests. This is the BDD approach of starting at the level of
an acceptance requirement, then drilling down to lower-level tests as part of satisfying that
requirement.

I paused to refactor a few times. The two main refactorings were:

- Cleaning up the sort (`<=>`) method on Jobs::Job to make it more readable
- Pulling the execution order generation algorithm out into a generator class to make what's
happening there more obvious

There are no tests for the `Jobs::ExecutionOrderGenerator` class. This is because the interface
I'm interested in testing is actually the `Jobs::execution_order(input)` method, which just
delegates to the `ExecutionOrderGenerator` class. The module method is also the one I was testing
against as I developed the code so adding tests for it afterwards would be artificial and
pointless.

I could have got rid of the `ExecutionOrderGenerator` class by declaring the algorithm steps in the
`Jobs` module and protecting the interface with something like this:

    module Jobs
      class << self

        def execution_order(input)
          output_in_execution_order(
            ensure_no_circular_dependencies(
              generate_jobs(input)
            )
          )
        end

        private

        def generate_jobs(input)
          # ...
        end

        def ensure_no_circular_dependencies(jobs)
          # ...
        end

        def output_in_execution_order(jobs)
          # ...
        end
      end
    end

I think the addition of the `ExecutionOrderGenerator` class really brings its value in making the
code cleaner. Also, repurposing a module to be a class like that is some pretty ugly
meta-programming!

Because they are nested method calls, the algorithm steps in
`ExecutionOrderGenerator#generate_jobs` read in reverse order. Three steps is about on my
borderline for splitting them up with local variables to have them read in order, like this:

    def generate_from(input)
      jobs = generate_jobs(input)
      ensure_no_circular_dependencies(jobs)
      output_in_execution_order(jobs)
    end

I think just the three calls reads fine as-is, though, so have left it as nested calls. That's
just my aesthetic preference. :)

## Final observations ##

That was the most fun I've had with a technical challenge, thank you! :)
