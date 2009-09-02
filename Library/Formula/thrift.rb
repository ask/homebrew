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

class Thrift <Formula
  @homepage='http://incubator.apache.org/thrift/'
  @head='http://svn.apache.org/repos/asf/incubator/thrift/trunk'

  def download_strategy
      SubversionDownloadStrategy
  end

  def pyprefix
    `python -c '#{PYTHON_GET_PREFIX}'`.strip()
  end

  def deployment_target
      `python -c '#{PYTHON_GET_DEPLOYMENT_TARGET}'`.strip()
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = nil
    ENV["PY_PREFIX"] = pyprefix
    system "cp /usr/X11/share/aclocal/pkg.m4 aclocal"
    system "bash bootstrap.sh"
    system "./configure --without-zlib --without-java --prefix='#{prefix}' --libdir='#{lib}'"
    system "make"
    system "make install"
  end
end
