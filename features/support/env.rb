$: << File.expand_path("../../../lib", __FILE__)

require "fix_spec/cucumber"
require "fix_spec/builder"

def last_fix
  @last_fix
end
