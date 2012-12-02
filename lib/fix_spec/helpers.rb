require 'multi_json'
module FIXSpec
  module Helpers
    extend self

    def message_to_unordered_json msg
      msg_hash = field_map_to_hash msg.get_header
      msg_hash.merge! field_map_to_hash msg
      msg_hash.merge! field_map_to_hash msg.get_trailer

      MultiJson.encode msg_hash
    end

    def message_to_json msg
      MultiJson.encode message_to_hash(msg)
    end

    def message_to_hash msg
      msg_hash = {}
      msg_hash[:header] = field_map_to_hash msg.get_header
      msg_hash[:body] = field_map_to_hash msg
      msg_hash[:trailer] = field_map_to_hash msg.get_trailer

      return msg_hash
    end

    def field_map_to_hash field_map
      hash = {}
      iter = field_map.iterator

      while iter.has_next 
        field = iter.next()
        tag = field.get_tag
        value = field.get_value

        hash[tag] = value
      end

      return hash
    end
  end
end
