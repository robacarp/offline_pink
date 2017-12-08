h3 == domain.name

| Checking #{domain.routes.size} routes:
- domain.routes.each do |route|
  == route.path

a href="/domain/#{domain.id}/routes/new" Create a route
