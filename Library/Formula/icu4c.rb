require 'brewkit'

class Icu4c <Formula
  @url='http://download.icu-project.org/files/icu4c/4.2.1/icu4c-4_2_1-src.tgz'
  @homepage='http://site.icu-project.org/'
  @md5='e3738abd0d3ce1870dc1fd1f22bba5b1'

  def version
    "4.2.1"
  end
  
  def install
    config_flags = ["MacOSX", "--prefix=#{prefix}", "--disable-samples", "--enable-static"]
    config_flags << "--with-library-bits=64" if hw_model == :core2
    Dir.chdir "source" do
      system "./runConfigureICU", *config_flags
      system "make"
      system "make install"
    end
  end
end
