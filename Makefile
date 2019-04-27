.DEFAULT_GOAL := deploy
.PHONY: calendar build deploy
MAKEFLAGS += --no-builtin-rules

source/_calendar.erb source/calendar.ics source/atom.xml: calendar/calendar.yaml
	./bin/rake calendar
calendar: source/_calendar.erb source/calendar.ics source/atom.xml

build: calendar
	./bin/middleman build

deploy: calendar
	./bin/middleman deploy -e production
