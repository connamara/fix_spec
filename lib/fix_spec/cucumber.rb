require File.expand_path("../../fix_spec", __FILE__)

World(JsonSpec::Helpers, JsonSpec::Matchers)
World(FIXSpec::Matchers)

Then /^the FIX message type should( not)? be "(.*?)"$/ do |negative, msg_type|

  unless FIXSpec::data_dictionary.nil?
    msg_type = FIXSpec::data_dictionary.get_msg_type(msg_type)
  end

  if negative
    last_fix.header.get_string(35).should_not == msg_type
  else
    last_fix.header.get_string(35).should == msg_type
  end
end

Then /^the (?:fix|FIX)(?: message)? at(?: tag)? "(.*?)" should( not)? be (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/ do |tag, negative, exp_value|
  if negative
    last_fix.should_not be_fix_eql(exp_value).at_path(tag)
  else
    last_fix.should be_fix_eql(exp_value).at_path(tag)
  end
end

Then /^the (?:fix|FIX)(?: message)?(?: at(?: tag)? "(.*?)")? should( not)? be:$/ do |tag, negative, exp_value|
  if tag.nil? and exp_value.match(/{*}/).nil?
    require 'fix_spec/builder'
    factory = quickfix.DefaultMessageFactory.new
    exp_message = FIXSpec::Builder.message = quickfix.MessageUtils.parse(factory, nil, FIXSpec::Helpers.fixify_string(exp_value) )
    exp_value = FIXSpec::Helpers.message_to_unordered_json(exp_message)
  end

  if negative
    last_fix.should_not be_fix_eql(exp_value).at_path(tag)
  else
    last_fix.should be_fix_eql(exp_value).at_path(tag)
  end
end

Then /^the (?:FIX|fix)(?: message)?(?: at "(.*)")? should have the following:$/ do |base, table|
  table.raw.each do |path, value|
    path = [base, path].compact.join("/")

    if value
      puts %(the fix at "#{path}" should be:), value
      step %(the fix at "#{path}" should be:), value
    else
      puts %(the fix should have "#{path}")
      step %(the fix should have "#{path}")
    end
  end
end

Then /^the (?:fix|FIX)(?: message)? should( not)? have(?: tag)? "(.*)"$/ do |negative, path|
  if negative
    last_fix.should_not have_fix_path(path)
  else
    last_fix.should have_fix_path(path)
  end
end
