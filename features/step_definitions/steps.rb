When /^I get the fix message$/ do
  @last_fix = FIXSpec::Builder.message
end
