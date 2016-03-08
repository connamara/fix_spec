#encoding ascii

require 'rexml/document'

module FIXSpec
  class DataDictionary < quickfix.DataDictionary
    attr_reader :fileName

    def initialize(fileName)
      @fileName = fileName

      super(@fileName)
    end

    def reverse_lookup
      @reverse_lookup ||= parse_xml
    end

    def get_reverse_value_name(tag, name)
      if(reverse_lookup[tag].has_key?(name))
        reverse_lookup[tag][name]
      else
        name
      end
    end

    private

    def parse_xml
      lookup = {}

      doc = REXML::Document.new File.new(@fileName)

      doc.elements.each("fix/fields/field") do |f|
        tag = f.attributes['number'].to_i
        lookup[tag]||={}

        f.elements.each("value") do |v|
          lookup[ tag ][v.attributes['description'] ] = v.attributes['enum']
        end
      end

      #also map pretty msg type names
      doc.elements.each("fix/messages/message") do |m|
        lookup[35][m.attributes['name']] = m.attributes['msgtype']
      end

      lookup
    end
  end
end
