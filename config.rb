set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :site_url, 'https://xn--caf-vie-prive-dhbj.fr'

configure :development do
	activate :livereload
end

configure :build do
	activate :minify_css
	activate :minify_javascript

	require_relative 'lib/deploy.rb'
	activate :deploy do |deploy|
		config = YAML::load_file 'deploy.yaml'
		config.each { |k, v| deploy[k] = v }
	end
end
