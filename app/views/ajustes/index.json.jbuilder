json.array!(@ajustes) do |ajuste|
  json.extract! ajuste, :id
  json.url ajuste_url(ajuste, format: :json)
end
