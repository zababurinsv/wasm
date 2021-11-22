ARCH			= native

DEPFILE			= newkind-$(ARCH).depend

CC_native		= gcc
CC_win64		= x86_64-w64-mingw32-gcc
CC_win32		= i686-w64-mingw32-gcc
CC				= $(CC_$(ARCH))

SRCS			= main.c
OBJS			= $(SRCS:.c=.o)

SDL_CFG_native	= sdl2-config
SDL_CFG_win64	= x86_64-w64-mingw32-sdl2-config
SDL_CFG_win32	= i686-w64-mingw32-sdl2-config

DLL				= SDL2.dll
DLL_SOURCE		= $(shell $(SDL_CFG_$(ARCH)) --prefix)/bin/$(DLL)

CFLAGS_native	= -std=c99 -pipe -Ofast -ffast-math -fno-common -falign-functions=16 -falign-loops=16 -Wall -I. $(shell $(SDL_CFG_native) --cflags)
#CFLAGS_native	= -g -std=c99 -pipe -O0 -fno-common -falign-functions=16 -falign-loops=16 -Wall -g -I. $(shell $(SDL_CFG_native) --cflags)
CFLAGS_win64	= -std=c99 -pipe -Ofast -ffast-math -fno-common -falign-functions=16 -falign-loops=16 -Wall -I. $(shell $(SDL_CFG_win64) --cflags)
CFLAGS_win32	= -std=c99 -pipe -Ofast -ffast-math -fno-common -falign-functions=16 -falign-loops=16 -Wall -I. $(shell $(SDL_CFG_win32) --cflags)
CFLAGS			= $(CFLAGS_$(ARCH))

LDFLAGS_native	= $(shell $(SDL_CFG_native) --libs) -lm
LDFLAGS_win64	= $(shell $(SDL_CFG_win64) --libs)
LDFLAGS_win32	= $(shell $(SDL_CFG_win32) --libs)
LDFLAGS			= $(LDFLAGS_$(ARCH))

EXE_native		= newkind
EXE_win64		= newkind-win64.exe
EXE_win32		= newkind-win32.exe
EXE				= $(EXE_$(ARCH))

ALLDEPS			= Makefile

all:
	$(MAKE) $(EXE) ARCH=$(ARCH)

.c.o: $(ALLDEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

$(DLL):
	test -s $(DLL_SOURCE) && cp $(DLL_SOURCE) $(DLL) || true

$(EXE): $(OBJS) $(ALLDEPS)
	$(MAKE) $(DLL) ARCH=$(ARCH)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)

$(DEPFILE): $(ALLDEPS) *.c *.h
	$(CC) -MM $(CFLAGS) $(SRCS) > $(DEPFILE)

clean:
	rm -fr ./dist/*.js ./dist/*.o ./dist/*.html ./dist/*.wasm ./dist/*.wasm.map ./dist/*.depend ./dist/*.data ./dist/*.mjs

distclean:
	$(MAKE) clean ARCH=$(ARCH)
	rm -f $(DEPFILE) *~ *.swp a.out datafilebank.c

.PHONY: dep all clean distclean install uninstall

