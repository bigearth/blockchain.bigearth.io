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
  
  def color_code_block_size block
    if block['size'].to_i <= 300000 
      color = 'success'
    elsif block['size'].to_i <= 700000 
      color ='warning'
    else
      color = 'danger'
    end
  end
end
