module Charts
  class HashRate 
    include Mongoid::Document
    field :time, type: Integer
    field :total, type: BigDecimal
  end  
end
