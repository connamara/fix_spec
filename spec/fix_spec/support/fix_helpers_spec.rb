require 'spec_helper'

describe 'support/fix_helpers mixin' do
  require 'fix_spec/support/fix_helpers'

  let(:app_dict) {FIXSpec::DataDictionary.new "features/support/FIX50SP1.xml" }
  let(:session_dict) {FIXSpec::DataDictionary.new "features/support/FIXT11.xml" }

  describe 'add_field' do
    before(:each) do
      FIXSpec::session_data_dictionary = session_dict
      FIXSpec::application_data_dictionary = app_dict
      @msgPart = new_message('News', 'FIXT.1.1') # msgtype doesn't matter for this test
    end

    it 'INT (not an enum)' do
      add_field(@msgPart,'TotNoOrders','123')
      @msgPart.to_s.should include('68=123')
    end

    it 'DAYOFMONTH' do
      add_field(@msgPart,'MaturityDay','15')
      @msgPart.to_s.should include('205=15')
    end

    it 'PRICE' do
      add_field(@msgPart,'StrikePrice','3.50')
      @msgPart.to_s.should include('202=3.5')
    end

    it 'FLOAT' do
      add_field(@msgPart,'PegOffsetValue','9.25')
      @msgPart.to_s.should include('211=9.25')
    end

    it 'QTY' do
      add_field(@msgPart,'CumQty','9.87')
      @msgPart.to_s.should include('14=9.87')
    end

    describe 'BOOLEAN' do
      it '"Y" if "true"' do
        add_field(@msgPart,'ForexReq','true')
        @msgPart.to_s.should include('121=Y')
      end
      it '"N" if anything but "true"' do
        add_field(@msgPart,'LocateReqd','swiss cake roll')
        @msgPart.to_s.should include('114=N')
      end
    end

    it 'STRING' do
      add_field(@msgPart,'Text','foobar')
      @msgPart.to_s.should include('58=foobar')
    end

    it 'CHAR (not an enum)' do
      add_field(@msgPart,'OptAttribute','h')
      @msgPart.to_s.should include('206=h')
    end

    describe 'enum-INT' do
      it 'convert if found' do
        add_field(@msgPart,'TradeRequestType','MATCHED_TRADES_MATCHING_CRITERIA_PROVIDED_ON_REQUEST')
        @msgPart.to_s.should include('569=1')
      end
      it 'use as-is if not found' do
        add_field(@msgPart,'TradeRequestType','JUDAS PRIEST')
        @msgPart.to_s.should include('569=JUDAS PRIEST')
      end
    end

    describe 'enum-CHAR' do
      it 'convert if found' do
        add_field(@msgPart,'SettlInstSource','INVESTOR')
        @msgPart.to_s.should include('165=3')
      end
      it 'use as-is if not found' do
        add_field(@msgPart,'SettlInstSource','BAD BUNNY')
        @msgPart.to_s.should include('165=BAD BUNNY')
      end
    end

    describe 'enum-STRING' do
      it 'convert if found' do
        add_field(@msgPart,'MatchType','ACT_M6_MATCH')
        @msgPart.to_s.should include('574=M6')
      end
      it 'use as-is if not found' do
        add_field(@msgPart,'MatchType',"green tea oh wait that's match-AH")
        @msgPart.to_s.should include("574=green tea oh wait that's match-AH")
      end
    end
  end
end
