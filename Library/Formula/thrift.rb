require 'brewkit'

# XXX have to set PY_PREFIX to the "prefix part" of the python binary
# location, to support virtualenvs. Might be a better way to do this.
#
# TODO Fix java support anyone?
#
#
#

PYTHON_GET_PREFIX = '
import sys
print(sys.executable.split("/bin")[0])
'

PYTHON_GET_DEPLOYMENT_TARGET = '
from distutils.sysconfig import parse_makefile, get_makefile_filename
m = parse_makefile(get_makefile_filename(), {})
print(m.get("MACOSX_DEPLOYMENT_TARGET"))
'

PATCH1='
--- /lib/cpp/src/concurrency/PosixThreadFactory.cpp	2008-11-24 14:36:45.000000000 -0800
+++ /lib/cpp/src/concurrency/PosixThreadFactory.cpp	2008-11-24 16:41:30.000000000 -0800
@@ -270,7 +270,7 @@
 
   Thread::id_t getCurrentThreadId() const {
     // TODO(dreiss): Stop using C-style casts.
-    return (id_t)pthread_self();
+    return (Thread::id_t)pthread_self();
   }
 
 };
'

class Thrift <Formula
  @homepage='http://incubator.apache.org/thrift/'
  @head='git://github.com/dreiss/thrift.git'

  def pyprefix
    `python -c '#{PYTHON_GET_PREFIX}'`.strip()
  end

  def deployment_target
      `python -c '#{PYTHON_GET_DEPLOYMENT_TARGET}'`.strip()
  end

  def env
      "env MACOSX_DEPLOYMENT_TARGET= PY_PREFIX=#{pyprefix}"
  end

  def install
    system "cp /usr/X11/share/aclocal/pkg.m4 aclocal"
    system "echo '#{PATCH1}' | patch -p1"
    system "#{env} bash bootstrap.sh"
    system "#{env} ./configure --without-zlib --without-java --prefix='#{prefix}' --libdir='#{lib}'"
    system "#{env} make"
    system "#{env} make install"
  end
end
