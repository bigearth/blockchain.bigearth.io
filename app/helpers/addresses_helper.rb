module AddressesHelper
  def color_tx_value tx_value
    tx_value < 0 ? 'danger' : 'success'
  end
end
