class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.11.2.tar.gz"
  sha256 "889a5d90a09ef837c0842a065dc2a8b95fb30603e054b7153d45fde33c19ad6b"

  livecheck do
    url "https://tools.netsa.cert.org/yaf/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "381c026a049cd90821c57cb05e97f66d1fd949c9e794578f9fa768132f67342d" => :big_sur
    sha256 "01a829d4aeb5fb22bee1fdf36859a514724ad593948301c195dd5dfc84b80168" => :catalina
    sha256 "72647a3208e653d43e51ff6539b9853e08ec8960cc5cda8820e9e750e4f37c9f" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = `#{bin}/yaf --in #{input} | #{bin}/yafscii`
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end
