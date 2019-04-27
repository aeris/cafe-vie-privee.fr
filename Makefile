.DEFAULT_GOAL := deploy
.PHONY: calendar deploy
MAKEFLAGS += --no-builtin-rules

source/_calendar.erb source/calendar.ics source/atom.xml: calendar/calendar.yaml
	./bin/rake calendar
calendar: source/_calendar.erb source/calendar.ics source/atom.xml

source/CNAME:
	echo xn--caf-vie-prive-dhbj.fr > "$@"

deploy: calendar source/CNAME
	./bin/middleman deploy -e production
