module ExplorersHelper
  def calculate_statistics statistic, type
    if statistic[0] === :size 
      number_to_human_size statistic[1].send type
    elsif statistic[0] === :fee
      "#{format_value statistic[1].send(type), 8} BTC" 
    else
      if statistic[0] === :days_destroyed || statistic[0] === :nb_txs
        format_value statistic[1].send(type), 1 
      else
        number_with_delimiter statistic[1].send(type), delimiter: ',' 
      end
    end 
  end
end
