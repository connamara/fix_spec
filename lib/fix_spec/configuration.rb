module FIXSpec
  module Configuration

    def data_dictionary=(dd)
      @data_dictionary=dd
    end

    def data_dictionary
      return @data_dictionary
    end

    def reset
      instance_variables.each{|ivar| remove_instance_variable(ivar)}
    end
  end
end
