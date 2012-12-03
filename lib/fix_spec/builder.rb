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
  FIXSpec::Builder.message = quickfix.MessageUtils.parse(factory, nil, FIXSpec::Helpers.fixify_string(fix_str) )
  FIXSpec::Builder.message.should_not be_nil
end
