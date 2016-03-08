module FIXSpec
  module Cucumber
    require 'cucumber'
    require 'cuke_mem'
    require 'fix_spec/support/fix_helpers'
    require 'fix_spec/step_definitions/fix_steps'
  end
end

World(JsonSpec::Helpers, JsonSpec::Matchers)
World(FIXSpec::Matchers)
