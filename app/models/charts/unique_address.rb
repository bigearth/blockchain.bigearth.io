module Charts
  class UniqueAddress
    include Mongoid::Document
    field :time, type: Integer
    field :total, type: BigDecimal
  end  
end
