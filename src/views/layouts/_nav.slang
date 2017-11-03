a class="nav-item" href="/" Home
- if logged_in?
  a class="nav-item" href="/checks" Checks
  a class="nav-item" href="/results" Results
  a class="nav-item" href="/sessions/destroy" Log out
- else
  a class="nav-item" href="/sessions/new" Log in
