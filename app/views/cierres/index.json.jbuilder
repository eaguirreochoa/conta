json.array!(@cierres) do |cierre|
  json.extract! cierre, :id
  json.url cierre_url(cierre, format: :json)
end
