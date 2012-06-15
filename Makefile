NACL_TOOLCHAIN_ROOT = $(NACL_SDK_ROOT)/toolchain/linux_x86_newlib
#NACL_TOOLCHAIN_ROOT = $(NACL_SDK_ROOT)/toolchain/linux_x86_glibc

#CC      = $(NACL_TOOLCHAIN_ROOT)/bin/nacl64-gcc
#CXX     = $(NACL_TOOLCHAIN_ROOT)/bin/nacl64-g++
#LD      = $(NACL_TOOLCHAIN_ROOT)/bin/nacl64-g++
CC      = $(NACL_TOOLCHAIN_ROOT)/bin/x86_64-nacl-gcc
CXX     = $(NACL_TOOLCHAIN_ROOT)/bin/x86_64-nacl-g++
LD      = $(NACL_TOOLCHAIN_ROOT)/bin/x86_64-nacl-g++

CFLAGS  += -O0 -g -ggdb3 -fno-inline -Wall
OBJS    = sdltest.o
CXXOBJS = plugin.o

SDL_CFLAGS = `$(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/usr/bin/sdl-config --cflags`
SDL_LIBS   = `$(NACL_TOOLCHAIN_ROOT)/x86_64-nacl/usr/bin/sdl-config --libs`
CFLAGS     += $(SDL_CFLAGS)
# Uncomment the following line for static linking with GLibC
# LIBS	+= -static -T ldscripts/elf64_nacl.x.static
#LIBS += $(SDL_LIBS) \
#-lppruntime \
#-lppapi_cpp \
#-lplatform \
#-lgio \
#-lpthread \
#-lsrpc

LIBS += $(SDL_LIBS) \
-lppapi_cpp \
-lppapi \
-lnosys

# stubs for all the system calls in SDL (signal)

all: sdltest

sdltest: $(OBJS) $(CXXOBJS)
	$(LD) -o $@ $^ $(LIBS)

$(OBJS): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(CXXOBJS): %.o: %.cc
	$(CXX) -c $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJS) $(CXXOBJS) sdltest
