require 'json_spec/messages'

module FIXSpec
  module Matchers
    class BeFIXEql
      include JsonSpec::Messages

      attr_reader :actual

      def initialize(expected_json = nil)
        @json_matcher= JsonSpec::Matchers::BeJsonEql.new expected_json
      end

      def at_path(path)
        @path=path
        @json_matcher.at_path path
        self
      end

      def matches?(fix)
        @json_matcher.matches? fix
      end

      def failure_message_for_should
        message_with_path("Expected equivalent FIX")
      end

      def negative_failure_message
        message_with_path("Expected inequivalent FIX")
      end

      def description
        message_with_path("equal FIX")
      end
    end
  end
end
