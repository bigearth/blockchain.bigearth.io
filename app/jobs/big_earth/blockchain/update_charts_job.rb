module BigEarth 
  module Blockchain 
    class UpdateChartsJob < ActiveJob::Base

      queue_as :update_charts_job

      def perform chart_type
        data = HTTParty.get "https://blockchain.info/charts/#{chart_type}?timespan=30days&format=json"
        parsed = JSON.parse data.body
        parsed['values'].each do |document|
          if chart_type == 'total-bitcoins'
            doc = Charts::Circulation.where time: document["x"]
            Charts::Circulation.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'market-cap'
            doc = Charts::MarketCap.where time: document["x"]
            Charts::MarketCap.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'transaction-fees'
            doc = Charts::TransactionFeeBtc.where time: document["x"] 
            Charts::TransactionFeeBtc.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'transaction-fees-usd'
            doc = Charts::TransactionFeeUsd.where time: document["x"] 
            Charts::TransactionFeeUsd.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'network-deficit'
            doc = Charts::NetworkDeficit.where time: document["x"] 
            Charts::NetworkDeficit.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'n-transactions'
            doc = Charts::TransactionDaily.where time: document["x"] 
            Charts::TransactionDaily.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'n-transactions-total'
            doc = Charts::TransactionTotal.where time: document["x"] 
            Charts::TransactionTotal.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'n-unique-addresses'
            doc = Charts::UniqueAddress.where time: document["x"] 
            Charts::UniqueAddress.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'n-transactions-per-block'
            doc = Charts::AverageTransaction.where time: document["x"] 
            Charts::AverageTransaction.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'n-orphaned-blocks'
            doc = Charts::OrphanedBlock.where time: document["x"] 
            Charts::OrphanedBlock.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'output-volume'
            doc = Charts::TotalOutput.where time: document["x"] 
            Charts::TotalOutput.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'market-price'
            doc = Charts::MarketPrice.where time: document["x"] 
            Charts::MarketPrice.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'hash-rate'
            doc = Charts::HashRate.where time: document["x"] 
            Charts::HashRate.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'difficulty'
            doc = Charts::Difficulty.where time: document["x"] 
            Charts::Difficulty.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'bitcoin-days-destroyed-cumulative'
            doc = Charts::DaysDestroyedCumulative.where time: document["x"] 
            Charts::DaysDestroyedCumulative.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'bitcoin-days-destroyed'
            doc = Charts::DaysDestroyed.where time: document["x"] 
            Charts::DaysDestroyed.create(time: document["x"], total: document["y"]) if doc.first.nil?
          elsif chart_type == 'blocks-size'
            doc = Charts::BlockSize.where time: document["x"] 
            Charts::BlockSize.create(time: document["x"], total: document["y"]) if doc.first.nil?
          end
        end
      end
    end
  end
end
