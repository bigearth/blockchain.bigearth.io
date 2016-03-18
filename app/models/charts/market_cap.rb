module Charts
  class MarketCap
    include Mongoid::Document
    field :time, type: Integer
    field :total, type: BigDecimal
  end  
end
