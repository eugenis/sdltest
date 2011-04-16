
CC	= $(NACL_TOOLCHAIN_ROOT)/bin/nacl64-gcc
CXX     = $(NACL_TOOLCHAIN_ROOT)/bin/nacl64-g++
LD      = $(NACL_TOOLCHAIN_ROOT)/bin/nacl64-g++
CFLAGS	+= -O0 -g -ggdb3 -fno-inline -Wall
OBJS	= sdltest.o
CXXOBJS	= plugin/pi_generator.o plugin/pi_generator_module.o

SDL_CFLAGS = `$(NACL_TOOLCHAIN_ROOT)/nacl64/usr/bin/sdl-config --cflags`
SDL_LIBS = `$(NACL_TOOLCHAIN_ROOT)/nacl64/usr/bin/sdl-config --libs`
CFLAGS	+= $(SDL_CFLAGS)
LIBS	+= -static -T ldscripts/elf64_nacl.x.static \
$(SDL_LIBS) \
-lppruntime \
-lppapi_cpp \
-lplatform \
-lgio \
-lpthread \
-lsrpc \
-lnosys

all: sdltest

sdltest: $(OBJS) $(CXXOBJS)
	$(LD) -o $@ $^ $(LIBS)

$(OBJS): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(CXXOBJS): %.o: %.cc
	$(CXX) -c $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJS) $(CXXOBJS) sdltest
