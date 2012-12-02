require 'fix_spec/matchers/be_fix_eql'
require 'fix_spec/matchers/have_fix_path'

module FIXSpec
  module Matchers
    def be_fix_eql(expected=nil)
      FIXSpec::Matchers::BeFIXEql.new(expected)
    end

    def have_fix_path(path)
      FIXSpec::Matchers::HaveFIXPath.new(path)
    end
  end
end

RSpec.configure do |config|
  config.include(FIXSpec::Matchers)
end
