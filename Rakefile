require 'yaml'
require 'erb'
require 'ostruct'
require 'digest'

task default: %i(calendar deploy)

def middleman(*args)
	system *(%w(bundle exec middleman) + args)
end

task build: %i(calendar) do
	middleman 'build'
end

task :deploy do
	middleman 'deploy'
end

task :serv do
	middleman 'server', '--port=3000'
end

def to_hour(sec)
	[sec / 3600, sec % 3600 / 60]
end

task :calendar do
	DAYS = %w(dimanche lundi mardi mercredi jeudi vendredi samedi)
	MONTHES = %w(janvier février mars avril mai juin juillet août septembre octobre novembre décembre)

	ENTRIES = {ics: [], atom: [], html: []}
	YAML.load(File.read 'calendar/calendar.yaml').sort! { |a, b| a['date']['end'] <=> b['date']['end'] }.each do |entry|
		day = entry['date']['day']
		case day
			when Date
				from = to = day
				html = 'le %s <b>%02d %s</b> %04d' % [DAYS[day.wday], day.day, MONTHES[day.month], day.year]
				atom = 'le %s %02d %s %s' % [DAYS[day.wday], day.day, MONTHES[day.month], day.year]
			when Hash
				from, to = day['from'], day['to']
				html = 'du %s <b>%02d</b> au %s <b>%02d %s</b> %04d' % [DAYS[from.wday], from.day, DAYS[to.wday], to.day, MONTHES[from.month], from.year]
				atom = 'du %s %02d au %s %02d %s %04d' % [DAYS[from.wday], from.day, DAYS[to.wday], to.day, MONTHES[from.month], from.year]
		end
		day = {from: from, to: to}

		hour = entry['date']['hour']
		case hour
			when Fixnum
				from, to = hour, nil
				html += ' à partir de <b>%02d:%02d</b>' % to_hour(from)
				atom += ' à partir de %02d:%02d' % to_hour(from)
			when Hash
				from, to = hour['from'], hour['to']
				hour = [to_hour(from), to_hour(to)].flatten
				html += ' de <b>%02d:%02d</b> à <b>%02d:%02d</b>' % hour
				atom += ' de %02d:%02d à %02d:%02d' % hour
		end
		hour = {from: from, to: to}

		internal_link, link = entry['internal_link'], entry['link']

		ENTRIES[:atom] << OpenStruct.new(location: '%s %s' % [entry['location']['prefix'], entry['location']['place']],
										 date: atom, created: entry['created'],
										 link: link ? link : "<%= URI.join config[:site_url], url_for('#{internal_link}') \%\>")
		if day[:to] >= Date.today
			link = internal_link || link
			location = '%s %s' % [entry['location']['prefix'],
								  link ? "<%= link_to \"#{entry['location']['place']}\", '#{link}' \%\>" : entry['location']['place']]
			ENTRIES[:html] << OpenStruct.new(date: html, created: entry['created'], location: location)
		end

		(day[:from]..day[:to]).each do |day|
			from = day.to_time + hour[:from]
			to = hour[:to] ? day.to_time + hour[:to] : day + 1
			ENTRIES[:ics] << OpenStruct.new(uid: Digest::SHA256.base64digest("#{entry['location']['place']}#{from}#{to}"),
											start: from, end: to, created: entry['created'], location: entry['location']['place'],
											link: link ? link : "<%= URI.join config[:site_url], url_for('#{internal_link}') \%\>")
		end
	end

	entries = ENTRIES[:atom]
	File.write 'source/atom.xml.erb', ERB.new(File.read('calendar/atom.erb'), nil, '-').result(binding)

	entries = ENTRIES[:html]
	File.write 'source/_calendar.erb', ERB.new(File.read('calendar/html.erb'), nil, '-').result(binding)

	entries = ENTRIES[:ics]
	File.write 'source/calendar.ics.erb', ERB.new(File.read('calendar/ics.erb'), nil, '-').result(binding)
end
