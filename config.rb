activate :livereload

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
  activate :minify_css
  activate :minify_javascript
end

activate :deploy do |deploy|
  deploy.method = :rsync
  deploy.host = 'acoeuro.com'
  deploy.path = 'prod/chiffro'
  deploy.port = 443
  deploy.build_before = true # default: false
end
