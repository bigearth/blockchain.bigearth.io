require 'test_helper'

module BigEarth
  module Blockchain
    class BlockrTest < ActiveSupport::TestCase
      setup do
        @blockr = BigEarth::Blockchain::Blockr.new
      end
      
      test 'the blockr webservice responds' do
        assert_equal 'success', @blockr.coin['status']
      end
      
      test 'the coin' do
        # TODO Figure out why the above line give the following error:
        # Minitest::Assertion: Expected #<HTTParty::Response...> to be an instance of HTTParty::Response, not HTTParty::Response.
        assert_instance_of Hash, @blockr.coin['data']
      end
      
      test 'the block' do
        assert_instance_of Hash, @blockr.block('404734')['data']
      end
      
      test 'the block fails' do
        assert_nil @blockr.block('')['data']
      end
      
      test 'the block txs' do
        assert_instance_of Hash, @blockr.block_txs('404734')['data']
      end
      
      test 'the block txs fails' do
        assert_nil @blockr.block_txs('')['data']
      end
      
      test 'the block raw' do
        assert_instance_of Hash, @blockr.block_raw('404734')['data']
      end
      
      test 'the block raw fails' do
        assert_nil @blockr.block_raw('')['data']
      end
      
      test 'the transactions' do
        assert_instance_of Hash, @blockr.transactions('8c3f41a9e705dc33ea3d6345ec26725d25ff77fc429b3fa7c84f73153aff80de')['data']
      end
      
      test 'the transactions fails' do
        assert_nil @blockr.transactions('')['data']
      end
      
      test 'the transactions raw' do
        assert_instance_of Hash, @blockr.transactions_raw('8c3f41a9e705dc33ea3d6345ec26725d25ff77fc429b3fa7c84f73153aff80de')['data']
      end
      
      test 'the transactions raw fails' do
        assert_nil @blockr.transactions_raw('')['data']
      end
    end
  end
end
