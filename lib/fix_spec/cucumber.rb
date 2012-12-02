require File.expand_path("../../fix_spec", __FILE__)

World(JsonSpec::Helpers, JsonSpec::Matchers)
World(FIXSpec::Matchers)

Then /^the FIX message type should( not)? be "(.*?)"$/ do |negative, msg_type|
  if negative
    last_fix.header.get_string(35).should_not == msg_type
  else
    last_fix.header.get_string(35).should == msg_type
  end
end

Then /^the (?:fix|FIX)(?: message)? at(?: tag)? "(.*?)" should( not)? be (".*"|\-?\d+(?:\.\d+)?(?:[eE][\+\-]?\d+)?|\[.*\]|%?\{.*\}|true|false|null)$/ do |tag, negative, exp_value|
  last_fix_json =  FIXSpec::Helpers.message_to_unordered_json(last_fix)


  if negative
    last_fix_json.should_not be_fix_eql(exp_value).at_path(tag)
  else
    last_fix_json.should be_fix_eql(exp_value).at_path(tag)
  end
end

Then /^the (?:fix|FIX)(?: message)?(?: at(?: tag)? "(.*?)")? should( not)? be:$/ do |tag, negative, exp_value|
  last_fix_json =  FIXSpec::Helpers.message_to_unordered_json(last_fix)

  if tag.nil? and exp_value.match(/{*}/).nil?
    require 'fix_spec/builder'
    factory = quickfix.DefaultMessageFactory.new
    exp_message = FIXSpec::Builder.message = quickfix.MessageUtils.parse(factory, nil, fixify(exp_value) )
    exp_value = FIXSpec::Helpers.message_to_unordered_json(exp_message)
  end

  if negative
    last_fix_json.should_not be_fix_eql(exp_value).at_path(tag)
  else
    last_fix_json.should be_fix_eql(exp_value).at_path(tag)
  end
end

Then /^the (?:FIX|fix)(?: message)?(?: at "(.*)")? should have the following:$/ do |base, table|
  table.rows.each do |path, value|
    path = [base, path].compact.join("/")

    if value
      step %(the fix at "#{path}" should be:), value
    else
      step %(the fix should have "#{path}")
    end
  end
end

Then /^the (?:fix|FIX)(?: message)? should( not)? have(?: tag)? "(.*)"$/ do |negative, path|
  last_fix_json =  FIXSpec::Helpers.message_to_unordered_json(last_fix)

  if negative
    last_fix_json.should_not have_fix_path(path)
  else
    last_fix_json.should have_fix_path(path)
  end
end
