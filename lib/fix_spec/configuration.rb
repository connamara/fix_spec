module FIXSpec
  module Configuration

    def data_dictionary=(dd)
      self.application_data_dictionary=dd
      self.session_data_dictionary=dd
    end

    def data_dictionary
      self.application_data_dictionary
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
  end
end
