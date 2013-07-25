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
      msg_hash.merge! field_map_to_hash msg, msg.get_msg_type
      msg_hash.merge! field_map_to_hash msg.get_trailer

      MultiJson.encode msg_hash
    end

    def message_to_hash msg
      msg_hash = field_map_to_hash msg.get_header
      msg_hash.merge! field_map_to_hash msg
      msg_hash.merge field_map_to_hash msg.get_trailer
    end

    def field_map_to_hash field_map, msg_type = nil
      hash = {}
      iter = field_map.iterator
      while iter.has_next 
        field = iter.next()
        tag = field.get_tag
        value = field.get_value

        if !FIXSpec::data_dictionary.nil?
          if !msg_type.nil? and FIXSpec::data_dictionary.is_group(msg_type, tag)
            groups = []
            for i in 1..value.to_i
              groups << field_map_to_hash( field_map.get_group(i,tag), msg_type )
            end
            value = groups
          elsif FIXSpec::data_dictionary.is_field(tag)
            value = case FIXSpec::data_dictionary.get_field_type_enum(tag).get_name
              when "INT","DAYOFMONTH" then value.to_i
              when "PRICE","FLOAT","QTY" then value.to_f
              when "BOOLEAN" then value == "Y"
              when "NUMINGROUP" then value = field_map.to_hash(value)
              else 
                value_name = FIXSpec::data_dictionary.get_value_name(tag, value)
                unless value_name.nil?
                  value_name
                else
                  value
                end
            end
          end
          tag = FIXSpec::data_dictionary.get_field_name(tag)
        end
        hash[tag] = value
      end

      return hash
    end
  end
end
