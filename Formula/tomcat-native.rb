class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.25/source/tomcat-native-1.2.25-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.25/source/tomcat-native-1.2.25-src.tar.gz"
  sha256 "b62f29ebd1f5df25ea33698427d7eb53e3bbde953dfbcc0c9c4c6c13ed23a33b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "4b6c29db536582d170a979ca5fec140d3a252576a0ac587de45f0cc4517917a0" => :catalina
    sha256 "48d5b5a3e06e33fb8c861caa75817e95081e5198f872090c97b2d247f355b895" => :mojave
    sha256 "9fa1374046bc6bd35c13e6f82c1066a50fbda6ed31cd18efc658816caa5ea561" => :high_sierra
  end

  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@1.1"
  depends_on "tomcat"

  def install
    cd "native" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{Formula["apr"].opt_prefix}",
                            "--with-java-home=#{Formula["openjdk"].opt_prefix}",
                            "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"

      # fixes occasional compiling issue: glibtool: compile: specify a tag with `--tag'
      args = ["LIBTOOL=glibtool --tag=CC"]
      # fixes a broken link in mountain lion's apr-1-config (it should be /XcodeDefault.xctoolchain/):
      # usr/local/opt/libtool/bin/glibtool: line 1125:
      # /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc:
      # No such file or directory
      args << "CC=#{ENV.cc}"
      system "make", *args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      In order for tomcat's APR lifecycle listener to find this library, you'll
      need to add it to java.library.path. This can be done by adding this line
      to $CATALINA_HOME/bin/setenv.sh

        CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{opt_lib}\"

      If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
