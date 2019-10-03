Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['ORIGIN_ALLOWED']
    resource(
      '*',
      headers: :any,
      methods: [:get, :patch, :put, :delete, :post, :options],
      credentials: true
    )
  end
end