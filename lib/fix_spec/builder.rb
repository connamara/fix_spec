module FIXSpec
  module Builder
    def self.message
      @message
    end

    def self.message= msg
      @message=msg
    end

    # Converts a FIX message string into a +quickfix.Message+.
    #
    # Params:
    # +msg_string+:: the FIX message string
    # +do_validation+:: if true, validation is performed using the DataDictionary
    #
    # Returns:
    # +quickfix.Message+
    #
    # See also:
    # +quickfix.MessageUtils#parse(Session, String)+
    def self.parse_message msg_string, do_validation
      begin_string = quickfix.MessageUtils.getStringField(msg_string, quickfix.field.BeginString::FIELD)
      msg_type = quickfix.MessageUtils.getMessageType(msg_string)
      payload_dict = quickfix.MessageUtils.isAdminMessage(msg_type) ? FIXSpec::session_data_dictionary : FIXSpec::application_data_dictionary
      msg = quickfix.DefaultMessageFactory.new.create(begin_string, msg_type)
      msg.parse(msg_string, FIXSpec::session_data_dictionary, payload_dict, do_validation)
      msg
    end
  end
end

