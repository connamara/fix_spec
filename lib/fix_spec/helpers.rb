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
      MultiJson.encode message_to_hash(msg)
    end

    def message_to_hash msg
      header = msg.get_header
      msg_type = extract_message_type header
      msg_hash = field_map_to_hash header
      msg_hash.merge! field_map_to_hash msg, FIXSpec::data_dictionary, msg_type
      msg_hash.merge field_map_to_hash msg.get_trailer
    end

    def extract_message_type msg
      if msg.is_set_field( quickfix::field::MsgType::FIELD)
        msg.get_field(quickfix::field::MsgType::FIELD).get_value
      else
        nil
      end
    end

    def find_field_type tag, data_dictionaries = []
      data_dictionaries.each do |dd|
        enum = dd.get_field_type(tag)
        value = enum.name unless enum.nil?
        return value unless value.nil? or value.eql?("")
      end
    end

    def find_field_name tag, data_dictionaries = []
      data_dictionaries.each do |dd|
        value = dd.get_field_name(tag)
        return value unless value.nil? or value.eql?("")
      end
    end

    def field_map_to_hash field_map, data_dictionary = FIXSpec::data_dictionary, msg_type = nil, all_dictionaries = [ data_dictionary ]
      hash = {}
      iter = field_map.iterator
      while iter.has_next 
        field = iter.next()
        tag = field.get_tag
        value = field.get_value

        if !data_dictionary.nil?
          if !msg_type.nil? and data_dictionary.is_group(msg_type, tag)
            group_dd = data_dictionary.get_group(msg_type,tag).get_data_dictionary 
            groups = []
            for i in 1..value.to_i
              groups << field_map_to_hash( field_map.get_group(i,tag), group_dd,  msg_type,Array.new(all_dictionaries) << group_dd  )
            end
            value = groups
          elsif data_dictionary.is_field(tag)
            value = case find_field_type(tag,all_dictionaries)
              when "INT","DAYOFMONTH" then value.to_i
              when "PRICE","FLOAT","QTY" then value.to_f
              when "BOOLEAN" then value == "Y"
              when "NUMINGROUP" then value = field_map.to_hash(value)
              else 
                value_name = data_dictionary.get_value_name(tag, value)
                unless value_name.nil?
                  value_name
                else
                  value
                end
            end
          end
          tag = find_field_name(tag,all_dictionaries) 
        end
        hash[tag] = value
      end

      return hash
    end
  end
end
