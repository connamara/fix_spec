module FIXSpec
  module Matchers
    class BeFIXEql
      include FIXSpec::Helpers

      def initialize(expected_fix_as_json = nil)
        @json_matcher= JsonSpec::Matchers::BeJsonEql.new expected_fix_as_json
      end

      def diffable?
        @json_matcher.diffable?
      end

      def actual
        @json_matcher.actual
      end

      def expected
        @json_matcher.expected
      end

      def at_path(path)
        @json_matcher.at_path path
        self
      end

      def matches?(fix_message)
        fix_json =  message_to_unordered_json(fix_message)

       @json_matcher.matches? fix_json
      end

      def failure_message_for_should
        @json_matcher.message_with_path("Expected equivalent FIX")
      end

      def negative_failure_message
        @json_matcher.message_with_path("Expected inequivalent FIX")
      end

      def description
        @json_matcher.message_with_path("equal FIX")
      end
    end
  end
end
