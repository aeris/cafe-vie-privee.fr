require 'yaml'
require 'erb'
require 'ostruct'
require 'digest'
require 'icalendar'
require 'atom'

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
	MONTHES = %w(NONE janvier février mars avril mai juin juillet août septembre octobre novembre décembre)

	ENTRIES = {ics: [], atom: [], html: []}
	YAML.load(File.read 'calendar/calendar.yaml').sort! do |a, b|
		a_day = a['date']['day']
		a_day = a_day['from'] if a_day.is_a? Hash

		b_day = b['date']['day']
		b_day = b_day['from'] if b_day.is_a? Hash

		a_day <=> b_day
	end.each do |entry|
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
										 link: link ? link : "https://xn--caf-vie-prive-dhbj.fr#{internal_link}")
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
											link: link ? link : "https://xn--caf-vie-prive-dhbj.fr#{internal_link}")
		end
	end

	entries = ENTRIES[:atom]
	#File.write 'source/atom.xml.erb', ERB.new(File.read('calendar/atom.erb'), nil, '-').result(binding)
	atom = Atom::Feed.new do |f|
		f.title = 'Café Vie Privé'
		f.subtitle = 'Chiffrofêtes / Cafés Vie Privée organisés à Paris et ailleurs'
		f.links << Atom::Link.new(href: 'https://xn--caf-vie-prive-dhbj.fr/atom.xml', rel: :self, type: 'application/atom+xml')
		f.authors << Atom::Person.new(name: 'Café Vie Privée')
		f.updated = Time.now
		f.id = 'urn:uuid:94de6d66-bc47-11e5-aa86-5bda2d727dba'

		f.entries =  entries.reverse.collect do |entry|
			Atom::Entry.new do |e|
				e.title = "Café Vie Privée #{entry.location} #{entry.date}"
				e.id = "urn:sha1:#{Digest::SHA1.hexdigest e.title}"
				e.summary = e.title
				e.links << Atom::Link.new(href: entry.link) if entry.link
				e.updated = entry.created
			end
		end
	end
	File.write 'source/atom.xml', atom.to_xml

	entries = ENTRIES[:html]
	File.write 'source/_calendar.erb', ERB.new(File.read('calendar/html.erb'), nil, '-').result(binding)

	entries = ENTRIES[:ics]
	cal = Icalendar::Calendar.new
	entries.each do |entry|
		cal.event do |e|
			e.uid = entry.uid
			e.created = entry.created
			e.dtstart = entry.start
			e.dtend   = entry.end #Icalendar::Values::Date.new('20050429')
			e.summary = 'Café Vie Privée'
			e.location = entry.location
			(e.url = entry.link) if entry.link
		end
	end
	File.write 'source/calendar.ics', cal.to_ical
end
