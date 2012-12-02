module FIXSpec
  module Configuration
    def reset
      instance_variables.each{|ivar| remove_instance_variable(ivar)}
    end
  end
end
