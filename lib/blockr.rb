class Blockr
  include HTTParty
  base_uri 'http://btc.blockr.io/api/v1/'

  def initialize()
    # @auth = {:username => u, :password => p}
    @options = {}
  end

  def timeline()
    puts 'timeline called'
    # options.merge!({:basic_auth => @auth})
    self.class.get("coin/info", @options)
  end
end
