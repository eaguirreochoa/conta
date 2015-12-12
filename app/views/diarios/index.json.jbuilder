json.array!(@diarios) do |diario|
  json.extract! diario, :id
  json.url diario_url(diario, format: :json)
end
