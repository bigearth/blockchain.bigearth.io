require 'test_helper'

module BigEarth
  module Blockchain
    class BlockrTest < ActiveSupport::TestCase
      setup do
        @blockr = BigEarth::Blockchain::Blockr.new
      end
      
      test 'the coin' do
        # TODO Figure out why the above line give the following error:
        # Minitest::Assertion: Expected #<HTTParty::Response...> to be an instance of HTTParty::Response, not HTTParty::Response.
        assert_equal 'success', @blockr.coin['status']
      end
      
      test 'the block' do
        assert_equal 'success', @blockr.block('404734')['status']
      end
      
      test 'the block txs' do
        assert_equal 'success', @blockr.block_txs('404734')['status']
      end
      
      test 'the block raw' do
        assert_equal 'success', @blockr.block_raw('404734')['status']
      end
    end
  end
end
