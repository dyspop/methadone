Feature: Bootstrap a new command-line app
  As an awesome developer who wants to make a command-line app
  I should be able to use methadone to bootstrap it
  And get all kinds of cool things

  Background:
    Given the directory "tmp/newgem" does not exist

  Scenario: Bootstrap a new app from scratch
    When I successfully run `methadone tmp/newgem`
    Then the following directories should exist:
      |tmp/newgem                           |
      |tmp/newgem/bin                       |
      |tmp/newgem/lib                       |
      |tmp/newgem/lib/newgem                |
      |tmp/newgem/test                      |
      |tmp/newgem/features                  |
      |tmp/newgem/features/support          |
      |tmp/newgem/features/step_definitions |
    And the following files should exist:
      |tmp/newgem/newgem.gemspec                            |
      |tmp/newgem/Rakefile                                  |
      |tmp/newgem/Gemfile                                   |
      |tmp/newgem/bin/newgem                                |
      |tmp/newgem/features/newgem.feature                   |
      |tmp/newgem/features/support/env.rb                   |
      |tmp/newgem/features/step_definitions/newgem_steps.rb |
      |tmp/newgem/test/tc_something.rb                      |
    And the file "tmp/newgem/newgem.gemspec" should match /add_development_dependency\('grancher'/
    And the file "tmp/newgem/newgem.gemspec" should match /add_development_dependency\('aruba'/
    And the file "tmp/newgem/newgem.gemspec" should match /add_development_dependency\('rdoc'/
    Given I cd to "tmp/newgem"
    When I successfully run `rake -T`
    Then the output should contain:
    """
    rake build         # Build newgem-0.0.1.gem into the pkg directory
    rake clean         # Remove any temporary products.
    rake clobber       # Remove any generated file.
    rake clobber_rdoc  # Remove rdoc products
    rake features      # Run Cucumber features
    rake install       # Build and install newgem-0.0.1.gem into system gems
    rake publish       # Builds and pushes the gh-pages-branch
    rake publish_rdoc  # Publish rdoc on github pages and push to github
    rake rdoc          # Build the rdoc HTML Files
    rake release       # Create tag v0.0.1 and build and push newgem-0.0.1.gem to Rubygems
    rake rerdoc        # Force a rebuild of the RDOC files
    rake test          # Run tests
    """    
    When I run `rake`
    Then the exit status should be 0
    And the output should contain:
    """
    1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
    """
    And the output should contain:
    """
    1 scenario (1 passed)
    3 steps (3 passed)
    """

  Scenario: Won't squash an existing dir
    When I successfully run `methadone tmp/newgem`
    And I run `methadone tmp/newgem`
    Then the exit status should not be 0
    And the stderr should contain:
    """
    error: tmp/newgem exists, use --force to override
    """

  Scenario: WILL squash an existing dir if we use --force
    When I successfully run `methadone tmp/newgem`
    And I run `methadone --force tmp/newgem`
    Then the exit status should be 0

  Scenario: We must supply a dirname
    When I run `methadone`
    Then the exit status should not be 0
    And the stderr should contain:
    """
    error: app_dir required
    """

