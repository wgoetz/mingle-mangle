#!/bin/bash

git clone https://github.com/LibRaw/LibRaw.git
git clone https://github.com/LibRaw/LibRaw-demosaic-pack-GPL2.git
git clone https://github.com/LibRaw/LibRaw-demosaic-pack-GPL3.git

svn co http://rawstudio.org/svn/rawspeed RawSpeed

(cd RawSpeed;patch -p1 < ../LibRaw/RawSpeed/rawspeed.cpucount-unix.patch)

cat <<"EOF" > RawSpeed/CMakeLists.txt
cmake_minimum_required(VERSION 2.6)
# derived from darktable/src/external/rawspeed
# Check for libxml2 / broken cmake module can't be included in the foreach() below
find_package(LibXml2 2.6 REQUIRED)
include_directories(${LIBXML2_INCLUDE_DIR})
list(APPEND LIBS ${LIBXML2_LIBRARIES})
add_definitions(${LIBXML2_DEFINITIONS})

set(RAWSPEED_SOURCES
  "RawSpeed/CameraSensorInfo.cpp"
  "RawSpeed/RawParser.cpp"
  "RawSpeed/ArwDecoder.cpp"
  "RawSpeed/BitPumpJPEG.cpp"
  "RawSpeed/BitPumpMSB32.cpp"
  "RawSpeed/BitPumpMSB.cpp"
  "RawSpeed/BitPumpPlain.cpp"
  "RawSpeed/BlackArea.cpp"
  "RawSpeed/ByteStream.cpp"
  "RawSpeed/ByteStreamSwap.cpp"
  "RawSpeed/Camera.cpp"
  "RawSpeed/CameraMetaData.cpp"
  "RawSpeed/CameraMetadataException.cpp"
  "RawSpeed/ColorFilterArray.cpp"
  "RawSpeed/Common.cpp"
  "RawSpeed/Cr2Decoder.cpp"
  "RawSpeed/DngOpcodes.cpp"
  "RawSpeed/DngDecoder.cpp"
  "RawSpeed/DngDecoderSlices.cpp"
  "RawSpeed/FileIOException.cpp"
  "RawSpeed/FileMap.cpp"
  "RawSpeed/FileReader.cpp"
  "RawSpeed/IOException.cpp"
  "RawSpeed/LJpegDecompressor.cpp"
  "RawSpeed/LJpegPlain.cpp"
  "RawSpeed/NefDecoder.cpp"
  "RawSpeed/NikonDecompressor.cpp"
  "RawSpeed/OrfDecoder.cpp"
  "RawSpeed/PefDecoder.cpp"
  "RawSpeed/PentaxDecompressor.cpp"
  "RawSpeed/RawDecoder.cpp"
  "RawSpeed/RawDecoderException.cpp"
  "RawSpeed/RawImage.cpp"
  "RawSpeed/Rw2Decoder.cpp"
  "RawSpeed/StdAfx.cpp"
  "RawSpeed/TiffEntryBE.cpp"
  "RawSpeed/TiffEntry.cpp"
  "RawSpeed/TiffIFDBE.cpp"
  "RawSpeed/TiffIFD.cpp"
  "RawSpeed/TiffParser.cpp"
  "RawSpeed/TiffParserException.cpp"
  "RawSpeed/TiffParserHeaderless.cpp"
  "RawSpeed/TiffParserOlympus.cpp"
  "RawSpeed/RawImageDataU16.cpp"
  "RawSpeed/RawImageDataFloat.cpp"
  "RawSpeed/SrwDecoder.cpp"
    )

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O4 -fPIC")

add_library(rawspeed STATIC ${RAWSPEED_SOURCES})
target_link_libraries(rawspeed)
EOF

pushd RawSpeed
cmake .
make
popd



pushd LibRaw
patch -p1 <<"EOF"
diff --git a/Makefile.devel b/Makefile.devel
index 6a2fde1..3a06c13 100644
--- a/Makefile.devel
+++ b/Makefile.devel
@@ -8,16 +8,16 @@ CXX=g++
 CFLAGS=
 
 # RawSpeed Support
-CFLAGS+=-DUSE_RAWSPEED -I../RawSpeed -I/usr/local/include/libxml2
-LDADD+=-L../RawSpeed/RawSpeed/release -lrawspeed -L/usr/local/include -ljpeg -lxml2
+CFLAGS+=-DUSE_RAWSPEED -I../RawSpeed -I/usr/include/libxml2
+LDADD+=-L../RawSpeed -lrawspeed -ljpeg -lxml2
 RAWSPEED_DATA=../RawSpeed/data/cameras.xml
 
 
-CC=gcc48
-CXX=g++48
+#CC=gcc48
+#CXX=g++48
 CFLAGS+= -g -I. -pedantic  -Wno-long-long -Wno-overflow  -O4 -fopenmp
 # Haswell:
-CFLAGS+=-march=core-avx2 -mtune=core-avx2 -mavx2
+#CFLAGS+=-march=core-avx2 -mtune=core-avx2 -mavx2
 
 
 # LCMS support
@@ -26,12 +26,12 @@ CFLAGS+=-march=core-avx2 -mtune=core-avx2 -mavx2
 #LDADD+=-L/usr/local/lib -llcms
 
 # Jasper support for RedCine
-CFLAGS+=-DUSE_JASPER -I/usr/local/include
-LDADD+=-L/usr/local/lib -ljasper
+CFLAGS+=-DUSE_JASPER
+LDADD+=-ljasper
 
 # JPEG support for DNG
-CFLAGS+=-DUSE_JPEG -I/usr/local/include
-LDADD+=-L/usr/local/lib -ljpeg
+CFLAGS+=-DUSE_JPEG
+LDADD+=-ljpeg
 # LIBJPEG8:
 CFLAGS+=-DUSE_JPEG8
 
@@ -40,8 +40,8 @@ DPCFLAGS+=-I../LibRaw-demosaic-pack-GPL2
 CFLAGS+=-DLIBRAW_DEMOSAIC_PACK_GPL2
 
 # Demosaic Pack GPL3:
-#DPCFLAGS+=-I../LibRaw-demosaic-pack-GPL3
-#CFLAGS+=-DLIBRAW_DEMOSAIC_PACK_GPL3
+DPCFLAGS+=-I../LibRaw-demosaic-pack-GPL3
+CFLAGS+=-DLIBRAW_DEMOSAIC_PACK_GPL3
 
 DCRAW_GEN= internal/dcraw_common.cpp internal/dcraw_fileio.cpp
 DCRAW_LIB_OBJECTS=object/dcraw_common.o object/libraw_cxx.o object/libraw_datastream.o object/libraw_c_api.o object/dcraw_fileio.o object/demosaic_packs.o
@@ -101,7 +101,7 @@ bin/dcraw_emu: lib/libraw.a samples/dcraw_emu.cpp
 dcraw_binaries: bin/dcraw_dist
 
 bin/dcraw_dist: dcraw/dcraw.c Makefile.devel
-	$(CXX) -w -O4 -DLIBRAW_NOTHREADS -DNO_JPEG -DNO_LCMS -DNO_JASPER -I/usr/local/include -o bin/dcraw_dist dcraw/dcraw.c -lm -L/usr/local/lib 
+	$(CXX) -w -O4 -DLIBRAW_NOTHREADS -DNO_JPEG -DNO_LCMS -DNO_JASPER -o bin/dcraw_dist dcraw/dcraw.c -lm  
 
 regenerate:
 	${PP} -N -DDEFINES dcraw/dcraw.c  >internal/defines.h
EOF



make -f Makefile.devel
popd

ls -l LibRaw/bin
