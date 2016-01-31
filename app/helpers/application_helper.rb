module ApplicationHelper
  def create_page_title 
    if @block
      "Bitcoin Block #{number_with_delimiter(@block['data']['nb'], delimiter: ',')} - " 
    elsif @tx
      "Bitcoin Transaction #{@tx['data']['tx']} - " 
    elsif @address
      "Bitcoin Address #{@address['data']['address']} - " 
    elsif params[:action] === 'bookmarks'
      "Bitcoin Bookmarks - " 
    elsif params[:action] === 'calculator'
      "Bitcoin Calculator - " 
    end
  end
  
  def create_bookmark_type
    if @block
      'block'
    elsif @tx
      'transaction'
    elsif @address
      'address'
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
