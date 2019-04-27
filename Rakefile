task default: %i(deploy)

def middleman(*args)
	system *(%w(bundle exec middleman) + args)
end

task build: %i(calendar) do
	ENV['MM_ENV'] = 'build'
	middleman *%w(build)
end

task :serv do
	middleman *%w(server --port=3000)
end

task :calendar do
	require_relative 'lib/calendar.rb'
end
