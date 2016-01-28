module ApplicationHelper
  def create_page_title 
    if @block
      "Bitcoin Block #{number_with_delimiter(@block['data']['nb'], delimiter: ',')} - " 
    elsif @tx
      "Bitcoin Transaction #{@tx['data']['tx']} - " 
    elsif @address
      "Bitcoin Address #{@address['data']['address']} - " 
    end
  end
  
  def create_page_type
    if @block
      'block'
    elsif @tx
      'transaction'
    elsif @address
      'address'
    end
  end
end
