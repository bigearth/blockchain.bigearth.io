json.array!(@transactions) do |transaction|
  json.extract! transaction, :id
  json.url transaction_url(transaction, format: :json)
end
