json.array!(@proveedors) do |proveedor|
  json.extract! proveedor, :id
  json.url proveedor_url(proveedor, format: :json)
end
