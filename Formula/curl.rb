class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.73.0.tar.bz2"
  sha256 "cf34fe0b07b800f1c01a499a6e8b2af548f6d0e044dca4a29d88a4bee146d131"
  license "curl"
  revision 1

  livecheck do
    url "https://curl.haxx.se/download/"
    regex(/href=.*?curl[._-]v?(.*?)\.t/i)
  end

  bottle do
    sha256 "c0b3cffe72118976aae9ab1651e1372ee6714d7e06ff5fdefc06536a2407c5ce" => :big_sur
    sha256 "b4cacbe3fc84a0cd0ce1f1d58ab10e8eee299a69f940c95e92338af0cd379e22" => :catalina
    sha256 "2e9afad916d3e93d7ca3126caf99ae84498034f92e2b9430fe84c57111ac0c18" => :mojave
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn2"
  depends_on "libmetalink"
  depends_on "libssh2"
  depends_on "nghttp2"
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "rtmpdump"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    system "./buildconf" if build.head?

    openssl = Formula["openssl@1.1"]
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-ssl=#{openssl.opt_prefix}
      --with-ca-bundle=#{openssl.pkgetc}/cert.pem
      --with-ca-path=#{openssl.pkgetc}/certs
      --with-secure-transport
      --with-default-ssl-backend=openssl
      --with-gssapi
      --with-libidn2
      --with-libmetalink
      --with-librtmp
      --with-libssh2
      --without-libpsl
    ]

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
