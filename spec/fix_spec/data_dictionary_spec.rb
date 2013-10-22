require 'spec_helper'

describe FIXSpec::DataDictionary do
  let(:dict) {FIXSpec::DataDictionary.new "features/support/FIX42.xml" }

  it "is a quickfix.DataDictionary" do
    dict.is_a?(quickfix.DataDictionary).should be_true
  end

  describe "get_reverse_value_name" do
    it "gives me back the same if not an enum or if we are giving an enum" do
      dict.get_reverse_value_name(1, 'Ralph').should ==('Ralph')
    end

    it "gives me back the same if is an enum and no description matches" do
      dict.get_reverse_value_name(39, 'D').should ==('D')
    end

    it "knows enum lookup" do
      dict.get_reverse_value_name(54, 'BUY').should ==('1')
    end

    it "knows how to map msg type" do
      dict.get_reverse_value_name(35, 'NewOrderSingle').should ==('D')
    end
  end
end
