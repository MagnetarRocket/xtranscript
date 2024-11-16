# xtranscript - simple terminal
# See LICENSE file for copyright and license details.

include config.mk

SRC = xtranscript.c
OBJ = ${SRC:.c=.o}

all: options xtranscript

options:
	@echo xtranscript build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

config.h:
	cp config.def.h config.h

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

xtranscript: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f xtranscript ${OBJ} xtranscript-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p xtranscript-${VERSION}
	@cp -R LICENSE Makefile README config.mk config.def.h xtranscript.info xtranscript.1 ${SRC} xtranscript-${VERSION}
	@tar -cf xtranscript-${VERSION}.tar xtranscript-${VERSION}
	@gzip xtranscript-${VERSION}.tar
	@rm -rf xtranscript-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f xtranscript ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/xtranscript
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < xtranscript.1 > ${DESTDIR}${MANPREFIX}/man1/xtranscript.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/xtranscript.1
	@echo Please see the README file regarding the terminfo entry of xtranscript.
	@tic -s xtranscript.info

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/xtranscript
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/xtranscript.1

.PHONY: all options clean dist install uninstall
