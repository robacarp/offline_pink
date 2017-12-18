h3 == domain.name

| Checking #{domain.routes.size} routes:

- if domain.routes.any?
  ul
    - domain.routes.each do |route|
      li
        a href="/route/#{route.id}" == route.path

a href="/domain/#{domain.id}/routes/new" Create a route
