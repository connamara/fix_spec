module FIXSpec
  module Matchers
    class HaveFIXPath
      attr_reader :path
      def initialize path
        @path = path
        @json_matcher = JsonSpec::Matchers::HaveJsonPath.new path
      end

      def matches? fix_message
        fix_json =  FIXSpec::Helpers.message_to_unordered_json(fix_message)

        @json_matcher.matches? fix_json
      end

      def failure_message_for_should
        %(Expected FIX path "#{@path}")
      end

      def failure_message_for_should_not
        %(Expected no FIX path "#{@path}")
      end

      def description
        %(have Protobuf path "#{@path}")
      end
    end
  end
end
