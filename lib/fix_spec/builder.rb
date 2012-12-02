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

def fixify message
  message = message.strip
  message.gsub!(/10=\d\d\d\001$/,"")
  message.gsub!(/\00134=[0-9]*/,"")
  head = message.slice!(/^8=.*?[\001]/)

  return message if head.nil? 
  checksum = message.slice!(/([\001]|^)10=\d+\001$/)

  length = message.slice!(/([\001]|^)9=\d+\001/)
	length = "9=#{message.length}\001" if length.nil?
  checksum = "10=%03d\001" % (head + length + message).sum(8)
  return (head + length + message + checksum)
end

Given /^the following fix message:$/ do |fix_str|
  factory = quickfix.DefaultMessageFactory.new
  FIXSpec::Builder.message = quickfix.MessageUtils.parse(factory, nil, fixify(fix_str) )
end
