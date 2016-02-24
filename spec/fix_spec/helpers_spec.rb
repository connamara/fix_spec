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

  describe "#message_to_hash"  do
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

    context 'differences between 4 & 5' do
      let(:message_str) { "8=FIX.4.1\u00019=139\u000135=8\u000134=3\u000149=EXEC\u000152=20121105-23:24:42\u000156=BANZAI\u00016=0\u000111=1352157882577\u000114=0\u000117=1\u000120=0\u000131=0\u000132=0\u000137=1\u000138=10000\u000139=0\u000154=1\u000155=MSFT\u0001150=2\u0001151=0\u000110=059\u0001" }

      # Adding this so folks know steps to parse a fix string (it's a little convoluted right now)
      it 'correctly parses fix 4 messages' do
        FIXSpec::application_data_dictionary= FIXSpec::DataDictionary.new "features/support/FIX42.xml"
        msg = FIXSpec::Builder.parse_message(message_str, false)
        fix_hash = FIXSpec::Helpers.message_to_hash(msg)
        fix_hash.keys.all? do |key|
          expect(key).to be_a String
        end
      end
    end
  end

  describe "get-message-type function" do
    let(:order) {
      ord = quickfix.fix42.NewOrderSingle.new
      ord
    }
    let(:generic_message) {
      msg = quickfix.Message.new
      msg.setString( 8, "FIX.4.2" )
      msg.setInt( 9, 26 )
      msg.setString( 49, "ITG" )
      msg.setString( 56, "SILO" )
      msg.setInt( 205, 4 )
      msg.setInt( 10, 84 )
      msg
    }

    context "fix message with msgType field set" do
      let(:msg_type) { extract_message_type( order.get_header ) }

      it "should return the value of the msgType tag" do
        msg_type.should == "D"
      end
    end

    context "fix message from raw string with no message type" do
      let(:msg_type) { extract_message_type( generic_message.get_header ) }

      it "should not error out and return nil" do
        msg_type.should == nil
      end
    end
  end
end
