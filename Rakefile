require 'yaml'
require 'erb'

task default: %i(calendar deploy)

def middleman(*args)
    system *(%w(bundle exec middleman) + args)
end

task :build do
	middleman 'build'
end

task :deploy do
	middleman 'deploy'
end

task :serv do
	middleman 'server', '--port=3000'
end

task :calendar do
	ENTRIES = YAML.load File.read 'calendar/calendar.yaml'
	ENTRIES.sort! { |a, b| a['date']['end'] <=> b['date']['end'] }

	entries = ENTRIES.clone
	entries.each do |entry|
		link = entry['internal_link']
		entry['link'] = "<%= URI.join config[:site_url], url_for('#{link}') \%\>" if link
	end
	File.write 'source/atom.xml.erb', ERB.new(File.read('calendar/atom.erb'), nil, '-').result(binding)

	entries = ENTRIES.clone
	entries.select! { |e| e['date']['end'] >= Date.today }
	entries.each do |entry|
		link = entry['internal_link'] || entry['link']
		link = "<%= link_to \"#{entry['location']['place']}\", '#{link}' \%\>"
		link ||= entry['location']['place']
		entry['link'] = link
	end
	File.write 'source/_calendar.erb', ERB.new(File.read('calendar/html.erb'), nil, '-').result(binding)
end
