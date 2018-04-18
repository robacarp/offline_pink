nav.navbar.navbar-expand-lg.bg-dark
  a.navbar-brand href="#{root_path}"
    == %(Offline<span class="pink">.pink</span>)
  button.navbar-toggler type="button" data-toggle="collapse" data-target="#mainNavigation" aria-controls="mainNavigation" aria-expanded="false" aria-label="Toggle Navigation"
    span.navbar-toggler-icon

  #navbarSupportedContent.collapse.navbar-collapse
  ul.navbar-nav.mr-auto
    li.nav-item
    - if activated_user?
      li.nav-item
        a.nav-link href="#{domains_path}" Domains
    - if logged_in?
      li.nav-item
        a.nav-link href="#{destroy_session_path}" Log out
    - else
      li.nav-item
        a.nav-link href="#{new_session_path}" Log in
