# Copyright (c) 2012 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

#
# GNU Make based build file.  For details on GNU Make see:
# http://www.gnu.org/software/make/manual/make.html
#

#
# Project information
#
# These variables store project specific settings for the project name
# build flags, files to copy or install. In the examples it is typically
# only the list of sources and project name that will actually change and
# the rest of the makefile is boilerplate for defining build rules.
#
PROJECT:=sdltest
CXX_SOURCES:=plugin.cc
C_SOURCES:=sdltest.c


#
# Get pepper directory for toolchain and includes.
#
# If NACL_SDK_ROOT is not set, then assume it can be found a two directories up,
# from the default example directory location.
#
THIS_MAKEFILE:=$(abspath $(lastword $(MAKEFILE_LIST)))
NACL_SDK_ROOT?=$(abspath $(dir $(THIS_MAKEFILE))../..)

#
# Compute tool paths
#
#
OSNAME:=$(shell python $(NACL_SDK_ROOT)/tools/getos.py)
TC_PATH:=$(abspath $(NACL_SDK_ROOT)/toolchain/$(OSNAME)_x86_newlib)
CC:=$(TC_PATH)/bin/i686-nacl-gcc
CXX:=$(TC_PATH)/bin/i686-nacl-g++
LD:=$(TC_PATH)/bin/i686-nacl-g++

# Project Build flags
WARNINGS:=-Wno-long-long -Wall -Wswitch-enum -pedantic -Werror
SDL_CONFIG_32:=$(TC_PATH)/i686-nacl/usr/bin/sdl-config
SDL_CONFIG_64:=$(TC_PATH)/x86_64-nacl/usr/bin/sdl-config
CXXFLAGS:=-pthread -std=gnu++98 $(WARNINGS) `$(SDL_CONFIG_32) --cflags`
CFLAGS:=-pthread $(WARNINGS) `$(SDL_CONFIG_32) --cflags`
LDFLAGS_32:=`$(SDL_CONFIG_32) --libs` -LSDLmain -lppapi_cpp -lppapi -lnosys 
LDFLAGS_64:=`$(SDL_CONFIG_64) --libs` -LSDLmain -lppapi_cpp -lppapi -lnosys 

#
# Disable DOS PATH warning when using Cygwin based tools Windows
#
CYGWIN ?= nodosfilewarning
export CYGWIN


# Declare the ALL target first, to make the 'all' target the default build
all: $(PROJECT)_x86_32.nexe $(PROJECT)_x86_64.nexe

# Define 32 bit compile and link rules
x86_32_CXX_OBJS:=$(patsubst %.cc,%_32.o,$(CXX_SOURCES))
$(x86_32_CXX_OBJS) : %_32.o : %.cc $(THIS_MAKE)
	$(CXX) -o $@ -c $< -m32 -O0 -g $(CXXFLAGS)

x86_32_C_OBJS:=$(patsubst %.c,%_32.o,$(C_SOURCES))
$(x86_32_C_OBJS) : %_32.o : %.c $(THIS_MAKE)
	$(CC) -o $@ -c $< -m32 -O0 -g $(CFLAGS)

$(PROJECT)_x86_32.nexe : $(x86_32_C_OBJS) $(x86_32_CXX_OBJS)
	$(LD) -o $@ $^ -O0 -m32 -g $(LDFLAGS_32)

# Define 64 bit compile and link rules
x86_64_CXX_OBJS:=$(patsubst %.cc,%_64.o,$(CXX_SOURCES))
$(x86_64_CXX_OBJS) : %_64.o : %.cc $(THIS_MAKE)
	$(CXX) -o $@ -c $< -m64 -O0 -g $(CXXFLAGS)

x86_64_C_OBJS:=$(patsubst %.c,%_64.o,$(C_SOURCES))
$(x86_64_C_OBJS) : %_64.o : %.c $(THIS_MAKE)
	$(CC) -o $@ -c $< -m64 -O0 -g $(CFLAGS)

$(PROJECT)_x86_64.nexe : $(x86_64_C_OBJS) $(x86_64_CXX_OBJS)
	$(LD) -o $@ $^ -O0 -m64 -g $(LDFLAGS_64)

.PHONY: clean
clean:
	rm -f *.o
	rm -f *.nexe
