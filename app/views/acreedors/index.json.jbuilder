json.array!(@acreedors) do |acreedor|
  json.extract! acreedor, :id
  json.url acreedor_url(acreedor, format: :json)
end
