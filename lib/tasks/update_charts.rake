namespace :blockchain do
  desc "Runs nightly to fetch the most recent data for each chart (http://blockchain.bigearth.io/charts)"
  task update_charts: :environment do |task, args|
    [
      'total-bitcoins', 
      'market-cap', 
      'transaction-fees',
      'transaction-fees-usd',
      'network-deficit',
      'n-transactions',
      'n-transactions-total',
      'n-unique-addresses',
      'n-transactions-per-block',
      'n-orphaned-blocks',
      'output-volume',
      'market-price',
      'hash-rate',
      'difficulty',
      'bitcoin-days-destroyed-cumulative',
      'bitcoin-days-destroyed',
      'blocks-size'
    ].each do |chart_type|
      UpdateChartsJob.perform_later chart_type
    end
  end
end
