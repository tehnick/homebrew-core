class Morse < Formula
  desc "QSO generator and morse code trainer"
  homepage "http://www.catb.org/~esr/morse/"
  url "http://www.catb.org/~esr/morse/morse-2.5.tar.gz"
  sha256 "476d1e8e95bb173b1aadc755db18f7e7a73eda35426944e1abd57c20307d4987"
  license "BSD-2-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "adae05d8824303ba9aa4ab1c39e909c593cc63a61b4b6be26cc51afec37a2696" => :catalina
    sha256 "114581f2ca08f2cde40767654aba3752d03c0f9bf45f05e68ce56079fde8308c" => :mojave
    sha256 "cf3b1e007ccd9008513ec84b6411ccee4756d61e801902faad5cf4d5243a8b0f" => :high_sierra
  end

  depends_on "libx11"

  def install
    system "make", "all", "DEVICE=X11"
    bin.install "morse"
    man1.install "morse.1"
  end

  test do
    system "#{bin}/morse"
  end
end
