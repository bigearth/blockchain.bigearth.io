module ExplorersHelper
  def calculate_statistics statistic, type
    if statistic[0] === :size 
      number_to_human_size statistic[1].send type
    elsif statistic[0] === :fee
      "#{number_with_delimiter(number_with_precision(statistic[1].send(type), precision: 8), delimiter: ',')} BTC" 
    else
      number_with_delimiter statistic[1].send(type), delimiter: ',' 
    end 
  end
end
