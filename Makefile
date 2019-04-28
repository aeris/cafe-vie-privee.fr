.DEFAULT_GOAL := deploy
.PHONY: calendar build deploy gitlab-pages
MAKEFLAGS += --no-builtin-rules
export MM_ENV := production

source/_calendar.erb source/calendar.ics source/atom.xml: calendar/calendar.yaml
	./bin/rake calendar
calendar: source/_calendar.erb source/calendar.ics source/atom.xml

source/CNAME:
	echo xn--caf-vie-prive-dhbj.fr > "$@"

build: calendar
	./bin/middleman build

deploy: calendar source/CNAME
	./bin/middleman deploy

gitlab-pages: calendar
	./bin/middleman build --build-dir=public
