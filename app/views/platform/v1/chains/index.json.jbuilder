json.array!(@platform_v1_chains) do |platform_v1_chain|
  json.extract! platform_v1_chain, :id, :pub_key
  json.url platform_v1_chain_url(platform_v1_chain, format: :json)
end
