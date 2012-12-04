$: << File.expand_path("../../../lib", __FILE__)

require "fix_spec/cucumber"
require "fix_spec/builder"

def last_fix
  @last_fix
end

Around('@with_data_dictionary') do |scenario, block|
  FIXSpec::data_dictionary= quickfix.DataDictionary.new "/Users/chris/QFJ_RELEASE_1_5_2/core/src/main/resources/FIX42.xml"
  block.call
  FIXSpec::data_dictionary= nil
end

Around('@ignore_length_and_checksum') do |scenario, block|
  JsonSpec.excluded_keys=%w(CheckSum BodyLength)
  block.call
  JsonSpec.excluded_keys=JsonSpec::Configuration::DEFAULT_EXCLUDED_KEYS
end
