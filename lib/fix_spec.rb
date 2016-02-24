require 'quickfix'
require 'json_spec'
require 'pry'

module FIXSpec
  extend self

  def data_dictionary=(dd)
    application_data_dictionary=dd
    session_data_dictionary=dd
  end

  def data_dictionary
    application_data_dictionary
  end

  def application_data_dictionary=(dd)
    @application_data_dictionary=dd
  end

  def application_data_dictionary
    @application_data_dictionary
  end

  def session_data_dictionary=(dd)
    @session_data_dictionary=dd
  end

  def session_data_dictionary
    @session_data_dictionary
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
