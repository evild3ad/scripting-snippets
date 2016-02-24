#!/usr/bin/env python2.7

import zlib

str_object1 = open('activemime.mso.compressed', 'rb').read()
str_object2 = zlib.decompress(str_object1, zlib.MAX_WBITS|32)
f = open('activemime.mso.decompressed', 'wb')
f.write(str_object2)
f.close()