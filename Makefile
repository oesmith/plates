BREW_HOME=$(shell brew --config | grep HOMEBREW_PREFIX | cut -d ' ' -f 2)

CC=clang
CFLAGS=-O3 -ffast-math -Wall -msse2 -D HAVE_SSE2 -D HAVE_LIBJPEG -D HAVE_LIBPNG -I$(BREW_HOME)/include

CCV_FILES=ccv/lib/3rdparty/dsfmt/dSFMT.o \
					ccv/lib/3rdparty/kissfft/kiss_fft.o \
					ccv/lib/3rdparty/kissfft/kiss_fftnd.o \
					ccv/lib/3rdparty/kissfft/kiss_fftndr.o \
					ccv/lib/3rdparty/kissfft/kiss_fftr.o \
					ccv/lib/3rdparty/kissfft/kissf_fft.o \
					ccv/lib/3rdparty/kissfft/kissf_fftnd.o \
					ccv/lib/3rdparty/kissfft/kissf_fftndr.o \
					ccv/lib/3rdparty/kissfft/kissf_fftr.o \
					ccv/lib/3rdparty/sfmt/SFMT.o \
					ccv/lib/3rdparty/sha1/sha1.o \
					ccv/lib/ccv_algebra.o \
					ccv/lib/ccv_basic.o \
					ccv/lib/ccv_bbf.o \
					ccv/lib/ccv_cache.o \
					ccv/lib/ccv_classic.o \
					ccv/lib/ccv_daisy.o \
					ccv/lib/ccv_dpm.o \
					ccv/lib/ccv_ferns.o \
					ccv/lib/ccv_io.o \
					ccv/lib/ccv_memory.o \
					ccv/lib/ccv_mser.o \
					ccv/lib/ccv_numeric.o \
					ccv/lib/ccv_resample.o \
					ccv/lib/ccv_sift.o \
					ccv/lib/ccv_swt.o \
					ccv/lib/ccv_tld.o \
					ccv/lib/ccv_util.o

all: hello

hello: hello.o libccv.a
	$(CC) hello.o libccv.a -o hello -L $(BREW_HOME)/lib -lpng -ljpeg

hello.o: hello.c
	$(CC) -c hello.c -o hello.o $(CFLAGS) -Iccv/lib

libccv.a: $(CCV_FILES)
	ar rcs $@ $^

ccv_io.o: ccv/lib/ccv_io.c ccv/lib/ccv.h ccv/lib/ccv_internal.h ccv/lib/io/*.c
	$(CC) $< -o $@ -c $(CFLAGS)

%.o: %.c ccv/lib/ccv.h ccv/lib/ccv_internal.h
	$(CC) $< -o $@ -c $(CFLAGS)

clean:
	rm -f hello libccv.a $(CCV_FILES)
