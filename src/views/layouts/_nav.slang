nav.navbar.navbar-expand-lg.bg-dark
  a.navbar-brand href="/"
    | Offline
    span.pink .pink
  button.navbar-toggler type="button" data-toggle="collapse" data-target="#mainNavigation" aria-controls="mainNavigation" aria-expanded="false" aria-label="Toggle Navigation"
    span.navbar-toggler-icon

  #navbarSupportedContent.collapse.navbar-collapse
  ul.navbar-nav.mr-auto
    li.nav-item
    - if logged_in?
      li.nav-item
        a.nav-link href="/checks" Checks
      li.nav-item
        a.nav-link href="/results" Results
      li.nav-item
        a.nav-link href="/sessions/destroy" Log out
    - else
      li.nav-item
        a.nav-link href="/sessions/new" Log in
