json.array!(@catalogos) do |catalogo|
  json.extract! catalogo, :id
  json.url catalogo_url(catalogo, format: :json)
end
