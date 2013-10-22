#encoding ascii

require 'rexml/document'

module FIXSpec
  class DataDictionary < quickfix.DataDictionary

    def initialize fileName
      super fileName
      @reverse_lookup = Hash.new({})

      parse_xml(fileName)
    end

    def get_reverse_value_name(tag, name)
      if(@reverse_lookup[tag].has_key?(name))
        @reverse_lookup[tag][name]
      else
        name
      end
    end

    private

    def parse_xml fileName
      doc = REXML::Document.new File.new(fileName)
      doc.elements.each("fix/fields/field") do |f| 
        tag = f.attributes['number'].to_i

        f.elements.each("value") do |v|
          @reverse_lookup[ tag ][v.attributes['description'] ] = v.attributes['enum']
        end
      end

      #also map pretty msg type names
      doc.elements.each("fix/messages/message") do |m| 
        @reverse_lookup[35][m.attributes['name']] = m.attributes['msgtype']
      end
    end
  end
end
