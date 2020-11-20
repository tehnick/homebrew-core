class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git"

  stable do
    url "https://github.com/jubalh/nudoku/archive/2.0.0.tar.gz"
    sha256 "44d3ec1ff34a010910ac7a92f6d84e8a7a4678a966999b7be27d224609ae54e1"

    # gettext 0.20 compatibility.
    # Remove with next release.
    patch do
      url "https://github.com/jubalh/nudoku/commit/9a4ffc359fe72f6af0e3654ae19ae421ab941ea8.patch?full_index=1"
      sha256 "e4b52f5ac48bfd192f28ae4b3a2fb146c7bc1bec1a441e8e10f4ad90550d4e66"
    end
  end

  bottle do
    rebuild 1
    sha256 "f0ea69399c3ccabfe0c0dcf8da90ed52f046ec2b5f3bc4eb1077abd96bc14bc2" => :big_sur
    sha256 "6d6fd028d5f9eea08b6bd26446bd72ed953f79c47f17f80dcb211e5b53ebee21" => :catalina
    sha256 "25f52f7ccbc931c34d2af3c89902dcaa7ea47cab5c0e61d62890532f4fc7c036" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
