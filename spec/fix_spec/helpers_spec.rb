require 'spec_helper'

describe FIXSpec::Helpers do
  include described_class

  describe "fixify_string" do
    it "can calculate checksum" do
      msg="8=FIX.4.235=849=ITG56=SILO205=4"
      fix_msg = fixify_string msg
      fix_msg.end_with?("10=084").should be_true
    end

    it "can ignore existing checksum" do
      msg="8=FIX.4.235=849=ITG56=SILO205=410=045"
      fix_msg = fixify_string msg
      fix_msg.end_with?("10=084").should be_true
    end

    it "can calculate length" do
      msg="8=FIX.4.235=849=ITG56=SILO205=410=045"
      fix_msg = fixify_string msg
      fix_msg.start_with?("8=FIX.4.2\0019=26\001").should be_true
    end

    it "can ignore existing length" do
      msg="8=FIX.4.29=4535=849=ITG56=SILO205=410=045"
      fix_msg = fixify_string msg
      fix_msg.start_with?("8=FIX.4.2\0019=26\001").should be_true
    end


    it "will strip out spaces" do
      msg="    8=FIX.4.235=849=ITG56=SILO205=4    "
      fixify_string(msg).should ==("8=FIX.4.2\0019=26\00135=8\00149=ITG\00156=SILO\001205=4\00110=084\001")
    end

    it "should be generous with missing last soh" do
      msg="8=FIX.4.235=849=ITG56=SILO205=4"
      fixify_string(msg).should ==("8=FIX.4.2\0019=26\00135=8\00149=ITG\00156=SILO\001205=4\00110=084\001")

      msg="8=FIX.4.235=849=ITG56=SILO205=410=045"
      fixify_string(msg).should ==("8=FIX.4.2\0019=26\00135=8\00149=ITG\00156=SILO\001205=4\00110=084\001")
    end


  end

  describe "message-to-hash functions"  do
    let(:order) {
      ord = quickfix.fix42.NewOrderSingle.new
      ord.header.set(quickfix.field.TargetCompID.new "target")
      ord.header.set(quickfix.field.SenderCompID.new "sender")

      ord.set(quickfix.field.Account.new "account")
      ord.set(quickfix.field.OrderQty.new(100.0))
      ord.set(quickfix.field.Price.new(75.0))
      ord
    }

    context "field_map_to_hash" do
      let(:hash) { field_map_to_hash order.get_header }

      it "should have unordered tags" do
        hash[8].should=="FIX.4.2" 
        hash[35].should=="D" 
      end
    end

    context "message_to_hash" do
      let(:hash) { message_to_hash order }

      it "should have unordered tags from all message parts" do
        hash[8].should=="FIX.4.2" 
        hash[35].should=="D" 
        hash[1].should=="account"
        hash[44].should == "75"
        hash[38].should == "100"
      end
    end
  end
end
