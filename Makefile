all: spec release

lib:
	shards

spec: lib main.cr src/**/*.cr
	crystal spec

dorsum-web: lib main.cr src/**/*.cr
	crystal build --error-trace -o dorsum-web main.cr
	@strip dorsum-web
	@du -sh dorsum-web

release: lib main.cr src/**/*.cr
	crystal build --release -o dorsum-web main.cr
	@strip dorsum-web
	@du -sh dorsum-web

clean:
	rm -rf .crystal dorsum-web .deps .shards libs lib *.dwarf build

PREFIX ?= /usr/local

install: release
	install -d $(PREFIX)/bin
	install dorsum-web $(PREFIX)/bin