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
  
  def format_value value, precision
    number_with_delimiter(number_with_precision(value, precision: precision), delimiter: ',')
  end
  
  def create_bookmark_link 
    unless current_page?(root_url) || current_page?(apps_calculator_path)
      if current_page?(apps_bookmarks_path)
        link_to 'Clear All Bookmarks', '#', class: 'btn btn-sm clear_all_bookmarks' 
      elsif current_page?(apps_bookmarks_path) != '/apps/bookmarks'
        link_to 'Bookmark', '#', class: 'btn btn-sm create_bookmark', "data-bookmark_type" => create_bookmark_type, "data-page_id" => params[:id] 
      end
    end
  end
end
