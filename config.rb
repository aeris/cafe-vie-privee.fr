set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :site_url, 'https://xn--caf-vie-prive-dhbj.fr'

activate :sprockets

configure :development do
	activate :livereload
end

configure :build do
	activate :minify_css
	activate :minify_javascript
end

activate :deploy do |deploy|
	deploy.build_before = true
	deploy.clean = true
	deploy.deploy_method = :git
	# deploy.strategy = :submodule
	deploy.branch = 'gh-pages'
end
