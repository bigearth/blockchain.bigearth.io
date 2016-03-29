module BigEarth
  module Blockchain
    class Blockr 
      include HTTParty
      
      base_uri 'btc.blockr.io/api/v1'

      def coin
        self.class.get '/coin/info'
      end
      
      def block id
        self.class.get "/block/info/#{id}"
      end
      
      def block_txs id
        self.class.get "/block/txs/#{id}"
      end
      
      def block_raw id
        self.class.get "/block/raw/#{id}"
      end
      
      def transactions id
        self.class.get "/tx/info/#{id}"
      end
      
      def transactions_raw id
        self.class.get "/tx/raw/#{id}"
      end
    end 
  end
end
