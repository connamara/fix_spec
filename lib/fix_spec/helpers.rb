require 'multi_json'
module FIXSpec
  module Helpers
    extend self

    def fixify_string msg_str
      message = msg_str.strip
      begin_string = message.slice!(/^8=.*?[\001]/)

      raise "Message '#{msg_str}' has no begin string" if begin_string.nil?

      #nobody's perfect, allow for missing trailing soh 
      message+="\001" unless message.end_with?("\001")

      #auto-calc length and checksum, ignore any existing
      message.slice!(/^9=\d+\001/)
      message.gsub!(/10=\d\d\d\001$/,"")

      length = "9=#{message.length}\001"
      checksum = "10=%03d\001" % (begin_string + length + message).sum(8)
      return (begin_string + length + message + checksum)
    end

    def message_to_unordered_json msg
      msg_hash = field_map_to_hash msg.get_header
      msg_hash.merge! field_map_to_hash msg
      msg_hash.merge! field_map_to_hash msg.get_trailer

      MultiJson.encode msg_hash
    end

    def message_to_hash msg
      msg_hash = field_map_to_hash msg.get_header
      msg_hash.merge! field_map_to_hash msg
      msg_hash.merge field_map_to_hash msg.get_trailer
    end

    def field_map_to_hash field_map
      hash = {}
      iter = field_map.iterator

      while iter.has_next 
        field = iter.next()
        tag = field.get_tag
        value = field.get_value

        if !FIXSpec::data_dictionary.nil? and FIXSpec::data_dictionary.is_field(tag)
          value = case FIXSpec::data_dictionary.get_field_type_enum(tag).get_name
            when "INT","DAYOFMONTH" then value.to_i
            else value
          end

          tag = FIXSpec::data_dictionary.get_field_name(tag)
        end

        hash[tag] = value
      end

      return hash
    end
  end
end
