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
  add_field(FIXSpec::Builder.message, fieldName, fieldValue)
end

Given(/^I add the following "(.*?)" group:$/) do |grpType, table|
  FIXSpec::Builder.message.should_not be_nil

  # gets the field name for the first entry in the table
  delim_field = table.raw.first.first

  group = quickfix.Group.new(FIXSpec::data_dictionary.getFieldTag(grpType), FIXSpec::data_dictionary.getFieldTag(delim_field))

  table.raw.each do |fieldName, fieldValue|
    add_field(group, fieldName, fieldValue)
  end

  FIXSpec::Builder.message.addGroup(group)
end

def add_field msg_part, fieldName, fieldValue

  #kill quotes
  if fieldValue.match(/\"(.*)\"/)
    fieldValue=$1
  end

  tag = -1
  if !FIXSpec::data_dictionary.nil? 
    tag = FIXSpec::data_dictionary.getFieldTag(fieldName)
    
    if FIXSpec::data_dictionary.is_header_field(tag)
      msg_part = msg_part.get_header
    elsif FIXSpec::data_dictionary.is_trailer_field(tag)
      msg_part = msg_part.get_trailer
    end

    case FIXSpec::data_dictionary.get_field_type_enum(tag).get_name
      when "INT","DAYOFMONTH" then 
        msg_part.setInt(tag, fieldValue.to_i)
      when "PRICE","FLOAT","QTY" then 
        msg_part.setDouble(tag, fieldValue.to_f)
      when "BOOLEAN" then 
        msg_part.setBoolean(tag, fieldValue == "true")
      else
        #enum description => enum value
        #e.g. tag 54 "BUY"=>"1"
        fieldValue = FIXSpec::data_dictionary.get_reverse_value_name(tag, fieldValue)
        msg_part.setString(tag, fieldValue)
    end
  else
    tag = fieldName.to_i
    msg_part.setString(tag, fieldValue)
  end

end
