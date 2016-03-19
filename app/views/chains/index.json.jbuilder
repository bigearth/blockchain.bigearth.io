json.array!(@chains) do |chain|
  json.extract! chain, :id, :pub_key
  json.url chain_url(chain, format: :json)
end
