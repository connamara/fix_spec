#encoding ascii

module FIXSpec
module Builder
  def self.message
    @message
  end

  def self.message= msg
    @message=msg
  end
end
end
 
Given /^the following( unvalidated)? fix message:$/ do |unvalidated,fix_str|
  factory = quickfix.DefaultMessageFactory.new
  unless unvalidated
    FIXSpec::Builder.message = quickfix.MessageUtils.parse(factory, FIXSpec::data_dictionary, FIXSpec::Helpers.fixify_string(fix_str) )
  else
    FIXSpec::Builder.message = quickfix.MessageUtils.parse(factory, nil, FIXSpec::Helpers.fixify_string(fix_str) )
  end

  FIXSpec::Builder.message.should_not be_nil
end

Given /^I create a (?:fix|FIX|(.*)) message(?: of type "(.*)")?$/ do |begin_string, msg_type|
  FIXSpec::Builder.message = quickfix.Message.new

  unless begin_string.nil?
    steps %{And I set the FIX message at "BeginString" to "#{begin_string}"}
  end

  unless msg_type.nil?
    steps %{And I set the FIX message at "MsgType" to "#{msg_type}"}
  end
end

Given /^I create the following (?:fix|FIX|(.*)) message(?: of type "(.*)")?:$/ do |begin_string, msg_type, table|
  FIXSpec::Builder.message = quickfix.Message.new

  unless begin_string.nil?
    steps %{And I set the FIX message at "BeginString" to "#{begin_string}"}
  end

  unless msg_type.nil?
    steps %{And I set the FIX message at "MsgType" to "#{msg_type}"}
  end

  table.raw.each do |tag, value|
    steps %{And I set the FIX message at "#{tag}" to #{value}}
  end
end

Given /^I set the (?:FIX|fix) message at(?: tag)? "(.*?)" to (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/ do |fieldName, fieldValue|
  FIXSpec::Builder.message.should_not be_nil
  set_fields(FIXSpec::Builder.message, fieldName.split('/'), fieldValue)
end

Given(/^I add the following "(.*?)" group:$/) do |grpType, table|
  FIXSpec::Builder.message.should_not be_nil

  list_field_order = []
  table.raw.each do |fieldName, fieldValue|
    list_field_order.push(FIXSpec::data_dictionary.getFieldTag(fieldName))
  end

  group = quickfix.Group.new(FIXSpec::data_dictionary.getFieldTag(grpType), list_field_order.first, (list_field_order.to_java :int))

  table.raw.each do |fieldName, fieldValue|
    add_field(group, fieldName, fieldValue)
  end

  FIXSpec::Builder.message.addGroup(group)
end

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
      group = quickfix.Group.new tag, -1
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
    if FIXSpec::data_dictionary.is_header_field(tag)
      msgPart = msgPart.get_header
    elsif FIXSpec::data_dictionary.is_trailer_field(tag)
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
