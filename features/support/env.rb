$: << File.expand_path("../../../lib", __FILE__)

require "pry"
require "fix_spec"
require "fix_spec/cucumber"

def last_fix
  @last_fix
end

Around('@with_data_dictionary') do |scenario, block|
  FIXSpec::data_dictionary = FIXSpec::DataDictionary.new "features/support/FIX42.xml"
  block.call
  FIXSpec::data_dictionary = nil
end

Around('@with_data_dictionary', '@fix50') do |scenario, block|
  FIXSpec::application_data_dictionary = FIXSpec::DataDictionary.new "features/support/FIX50SP1.xml"
  FIXSpec::session_data_dictionary = FIXSpec::DataDictionary.new "features/support/FIXT11.xml"
  block.call
  FIXSpec::application_data_dictionary = nil
  FIXSpec::session_data_dictionary = nil
end

Around('@ignore_length_and_checksum') do |scenario, block|
  JsonSpec.excluded_keys=%w(CheckSum BodyLength)
  block.call
  JsonSpec.excluded_keys=JsonSpec::Configuration::DEFAULT_EXCLUDED_KEYS
end
