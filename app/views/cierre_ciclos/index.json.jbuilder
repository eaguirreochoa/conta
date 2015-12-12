json.array!(@cierre_ciclos) do |cierre_ciclo|
  json.extract! cierre_ciclo, :id
  json.url cierre_ciclo_url(cierre_ciclo, format: :json)
end
