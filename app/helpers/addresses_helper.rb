module AddressesHelper
  def color_tx_amount tx_value
    tx_value < 0 ? 'danger' : 'success'
  end
end
