module Charts
  class MarketCap
    include Mongoid::Document
    field :time, type: Integer
    field :total, type: Integer
  end  
end
