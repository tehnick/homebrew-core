class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.2.1.tar.gz"
  sha256 "539825f2be01ef287b686ea1d7f858e4473873526f2e5bf3ad8f0123d7d07910"

  livecheck do
    url "https://www.indexdata.com/resources/software/zebra"
    regex(%r{>Latest:</strong>.*?v?(\d+(?:\.\d+)+)<}i)
  end

  bottle do
    sha256 "0170e79fad9feed7da690f142a27cd8149e1dc296951096f6393bb9a56ddb705" => :catalina
    sha256 "ad92d99f1354fe779999274b9edbd6c727f3029374066de1c126784f4a0b3d8b" => :mojave
    sha256 "5e359e457056af03a4ffd268cc7f2295b411f6a122f2fcbec71d7f5ed174fc70" => :high_sierra
  end

  depends_on "icu4c"
  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari"
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
