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

Given /^the following fix message:$/ do |fix_str|
  factory = quickfix.DefaultMessageFactory.new
  FIXSpec::Builder.message = quickfix.MessageUtils.parse(factory, FIXSpec::data_dictionary, FIXSpec::Helpers.fixify_string(fix_str) )
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

  #kill quotes
  if fieldValue.match(/\"(.*)\"/)
    fieldValue=$1
  end

  tag = -1
  if !FIXSpec::data_dictionary.nil? 
    tag = FIXSpec::data_dictionary.getFieldTag(fieldName)
    
    if tag == -1 then
      FIXSpec::Builder.message.setString(fieldName, fieldValue)
      return
    end

    case FIXSpec::data_dictionary.get_field_type_enum(tag).get_name
      when "INT","DAYOFMONTH" then 
        FIXSpec::Builder.message.setInt(tag, fieldValue.to_i)
      when "PRICE","FLOAT","QTY" then 
        FIXSpec::Builder.message.setDouble(tag, fieldValue.to_f)
      when "BOOLEAN" then 
        FIXSpec::Builder.message.setBoolean(tag, fieldValue == "true")
      else
        
        FIXSpec::Builder.message.setString(tag, fieldValue)
    end

  else
    tag = fieldName.to_i
    FIXSpec::Builder.message.setString(tag, fieldValue)
  end
end



