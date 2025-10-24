PROG = recordctl
SECTION = 8

PREFIX ?= /usr/local
BINDIR = $(DESTDIR)$(PREFIX)/bin
MANDIR = $(DESTDIR)$(PREFIX)/man/man$(SECTION)

install:
	mkdir -p $(BINDIR)
	install -m 755 bin/$(PROG) $(BINDIR)
	mkdir -p $(MANDIR)
	install -m 644 man/$(PROG).$(SECTION) $(MANDIR)

uninstall:
	rm $(BINDIR)/$(PROG)
	rm $(MANDIR)/$(PROG).$(SECTION)
