# See LICENSE file for copyright and license details
# farbfeld - suckless image format with conversion tools
.POSIX:

include config.mk

SRC = src
REQ = util
HDR = arg.h
BIN = png2ff ff2png jpg2ff ff2jpg ff2pam ff2ppm
SCR = 2ff
MAN = man
MAN1 = 2ff.1 $(BIN:=.1)
MAN5 = farbfeld.5
INSTALL = install
RM = rm -fv

all: $(BIN)

png2ff-LDLIBS = $(PNG-LDLIBS)
ff2png-LDLIBS = $(PNG-LDLIBS)
jpg2ff-LDLIBS = $(JPG-LDLIBS)
ff2jpg-LDLIBS = $(JPG-LDLIBS)

png2ff: png2ff.o $(REQ:=.o)
ff2png: ff2png.o $(REQ:=.o)
jpg2ff: jpg2ff.o $(REQ:=.o)
ff2jpg: ff2jpg.o $(REQ:=.o)
ff2pam: ff2pam.o $(REQ:=.o)
ff2ppm: ff2ppm.o $(REQ:=.o)

.o:
	$(CC) -o $@ $(LDFLAGS) $< $(REQ:=.o) $($*-LDLIBS)

%.o: $(SRC)/%.c $(DEPS)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

clean:
	$(RM) $(BIN) $(BIN:=.o) $(REQ:=.o)

dist:
	rm -rf "farbfeld-$(VERSION)"
	mkdir -p "farbfeld-$(VERSION)"
	mkdir -p "farbfeld-$(VERSION)/$(SRC)"
	mkdir -p "farbfeld-$(VERSION)/$(MAN)"
	cp -R FORMAT LICENSE Makefile README config.mk $(SCR) \
	      $(SRC) $(MAN) "farbfeld-$(VERSION)"
	tar -cf - "farbfeld-$(VERSION)" | gzip -c > "farbfeld-$(VERSION).tar.gz"
	rm -rf "farbfeld-$(VERSION)"

install: all
	$(INSTALL) -d "$(DESTDIR)$(PREFIX)/bin"
	$(INSTALL) -m 0755 $(SCR) $(BIN) "$(DESTDIR)$(PREFIX)/bin"
	$(INSTALL) -d "$(DESTDIR)$(MANPREFIX)/man1"
	$(INSTALL) -m 0644 $(addprefix $(MAN)/,$(MAN1)) "$(DESTDIR)$(MANPREFIX)/man1"
	$(INSTALL) -d "$(DESTDIR)$(MANPREFIX)/man5"
	$(INSTALL) -m 0644 $(addprefix $(MAN)/,$(MAN5)) "$(DESTDIR)$(MANPREFIX)/man5"

uninstall:
	$(RM) "$(addprefix $(DESTDIR)$(PREFIX)/bin/,$(BIN))"
	$(RM) "$(addprefix $(DESTDIR)$(PREFIX)/bin/,$(SRC))"
	$(RM) "$(addprefix $(DESTDIR)$(MANPREFIX)/man1/,$(MAN1))"
	$(RM) "$(addprefix $(DESTDIR)$(MANPREFIX)/man5/,$(MAN5))"
