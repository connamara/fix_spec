require 'spec_helper'

describe FIXSpec::DataDictionary do
  let(:app_dict) {FIXSpec::DataDictionary.new "features/support/FIX50SP1.xml" }
  let(:session_dict) {FIXSpec::DataDictionary.new "features/support/FIXT11.xml" }

  it "is a quickfix.DataDictionary" do
    app_dict.is_a?(quickfix.DataDictionary).should be_true
    session_dict.is_a?(quickfix.DataDictionary).should be_true
  end

  describe "get_reverse_value_name" do
    it "gives me back the same if not an enum or if we are giving an enum" do
      app_dict.get_reverse_value_name(1, 'Ralph').should ==('Ralph')
      session_dict.get_reverse_value_name(49, 'Hagbard').should ==('Hagbard')
    end

    it "gives me back the same if is an enum and no description matches" do
      app_dict.get_reverse_value_name(39, 'D').should ==('D')
      session_dict.get_reverse_value_name(141, 'X').should ==('X')
    end

    it "knows enum lookup" do
      app_dict.get_reverse_value_name(54, 'BUY').should ==('1')
      app_dict.get_reverse_value_name(35, 'NEWORDERSINGLE').should ==('D')
      session_dict.get_reverse_value_name(35, 'ORDER_SINGLE').should ==('D')
    end

    it "knows how to map msg type" do
      app_dict.get_reverse_value_name(35, 'NewOrderSingle').should ==('D')
    end
  end
end
