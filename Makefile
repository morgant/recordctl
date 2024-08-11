install: bin/recordctl man/recordctl.1
	mkdir -p /usr/local/bin
	install -m755 bin/recordctl /usr/local/bin
	mkdir -p /usr/local/man/man1
	install -m444 man/recordctl.1 /usr/local/man/man1
