require 'quickfix'
require 'json_spec'

module FIXSpec
  extend self

  attr_reader :application_data_dictionary, :session_data_dictionary

  alias_method :data_dictionary, :application_data_dictionary

  def data_dictionary=(dd)
    @application_data_dictionary=dd
    @session_data_dictionary=dd
  end

  def application_data_dictionary=(dd)
    @application_data_dictionary=dd
  end

  def session_data_dictionary=(dd)
    @session_data_dictionary=dd
  end

  def reset
    instance_variables.each{|ivar| remove_instance_variable(ivar)}
  end

  autoload :Builder, 'fix_spec/builder'
  autoload :DataDictionary, 'fix_spec/data_dictionary'
  # don't load cucumber unless you're using it
  autoload :Cucumber, 'fix_spec/cucumber'
  autoload :Helpers, 'fix_spec/helpers'
  autoload :Matchers, 'fix_spec/matchers'
end

RSpec.configure do |config|
  config.include(FIXSpec::Matchers)
end
