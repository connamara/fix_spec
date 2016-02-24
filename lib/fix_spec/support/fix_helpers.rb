def set_fields msgPart, fieldName, fieldValue
  if fieldName.is_a? String
    add_field msgPart, fieldName, fieldValue
  elsif fieldName.is_a? Array
    if fieldName.length > 1
      add_array_field msgPart, fieldName, fieldValue
    else
      add_field msgPart, fieldName.first, fieldValue
    end
  end
end

def add_array_field msgPart, fieldArray, fieldValue
  if !FIXSpec::data_dictionary.nil?
    fieldName = fieldArray.shift
    tag = FIXSpec::data_dictionary.getFieldTag(fieldName)
    fail "#{fieldName} is not a valid field" if tag == -1

    arrayPosStr = fieldArray.shift
    arrayPos = arrayPosStr.to_i
    fail "#{arrayPos} is not a valid array index" unless arrayPos.to_s == arrayPosStr
    fail "You need to specify a field for group #{fieldName}" if fieldArray.empty?

    if msgPart.hasGroup(arrayPos+1, tag)
      set_fields msgPart.getGroup(arrayPos+1, tag), fieldArray, fieldValue
    else
      group = new_group(msgPart, fieldName)
      set_fields group, fieldArray, fieldValue
      msgPart.addGroup group
    end
  else
    fail "no data dictionary set"
  end
end

def add_field msgPart, fieldName, fieldValue
  #kill quotes
  if fieldValue.match(/\"(.*)\"/)
    fieldValue=$1
  end

  tag = -1
  if !FIXSpec::data_dictionary.nil?
    tag = FIXSpec::data_dictionary.getFieldTag(fieldName)
    if FIXSpec::session_data_dictionary.is_header_field(tag)
      msgPart = msgPart.get_header
    elsif FIXSpec::session_data_dictionary.is_trailer_field(tag)
      msgPart = msgPart.get_trailer
    end

    case FIXSpec::data_dictionary.get_field_type_enum(tag).get_name
      when "INT","DAYOFMONTH" then
        msgPart.setInt(tag, fieldValue.to_i)
      when "PRICE","FLOAT","QTY" then
        msgPart.setDouble(tag, fieldValue.to_f)
      when "BOOLEAN" then
        msgPart.setBoolean(tag, fieldValue == "true")
      else
        #enum description => enum value
        #e.g. tag 54 "BUY"=>"1"
        fieldValue = FIXSpec::data_dictionary.get_reverse_value_name(tag, fieldValue)
        msgPart.setString(tag, fieldValue)
    end
  else
    tag = fieldName.to_i
    msgPart.setString(tag, fieldValue)
  end
end


# Tries to create a typed Message using a DefaultMessageFactory based on the given +msg_type+.
#
# This ensures that any repeating groups that are added to the Message will also be typed, and
# therefore have the correct delimiter and field order.
# Falls back to creating a base Message if +msg_type+ is nil.
def new_message msg_type=nil, begin_string=nil
  if msg_type.nil?
    msg = quickfix.Message.new
    msg.get_header.setString(8, begin_string) unless begin_string.nil?
    msg
  else
    quickfix.DefaultMessageFactory.new.create(FIXSpec::session_data_dictionary.get_version, FIXSpec::data_dictionary.get_reverse_value_name(35, msg_type))
  end
end

# Tries to create a typed Group based on the name of the parent Message.
#
# This ensures that the correct delimiter and field order is used when serializing/deserializing the Group.
# Falls back to creating a base Group if typed Group creation fails.
#
# Example:
#   If +msgPart+ is an instance of +Java::quickfix.fix50.MarketDataRequest+
#   And +fieldName+ is 'NoMDEntryTypes'
#   Then an instance of +Java::quickfix.fix50.MarketDataRequest::NoMDEntryTypes+ will be returned.
def new_group msgPart, fieldName
  group_class = java_import("#{msgPart.getClass.getName}\$#{fieldName}").first
  group_class.new
rescue
  quickfix.Group.new FIXSpec::data_dictionary.getFieldTag(fieldName), -1
end
