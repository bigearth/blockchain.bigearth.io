json.array!(@explorers) do |explorer|
  json.extract! explorer, :id
  json.url explorer_url(explorer, format: :json)
end
