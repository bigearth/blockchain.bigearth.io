module Charts
  class TransactionFeeUsd
    include Mongoid::Document
    field :time, type: Integer
    field :total, type: BigDecimal
  end  
end
