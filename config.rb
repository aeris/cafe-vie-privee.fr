activate :livereload

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :site_url, 'https://xn--caf-vie-prive-dhbj.fr'

configure :build do
	activate :minify_css
	activate :minify_javascript
end

activate :deploy do |deploy|
	config = YAML::load_file 'deploy.yaml'
	deploy.method = config['method']
	deploy.host = config['host']
	deploy.path = config['path']
	deploy.port = config['port']
	deploy.build_before = config['build_before']
end
