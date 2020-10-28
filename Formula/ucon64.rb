class Ucon64 < Formula
  desc "ROM backup tool and emulator's Swiss Army knife program"
  homepage "https://ucon64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ucon64/ucon64/ucon64-2.2.0/ucon64-2.2.0-src.tar.gz"
  sha256 "5727e0be9ee878bba84d204135a7ca25662db6b56fee6895301e50c1bdda70af"
  license "GPL-2.0"
  head "https://svn.code.sf.net/p/ucon64/svn/trunk/ucon64"

  livecheck do
    url :stable
    regex(%r{url=.*?/ucon64[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    sha256 "f0bf36d7828e138e2fe1068b4b5bf1b9e70f80cef564c186950a30ab2cb1df85" => :catalina
    sha256 "893570e77b17c3400f391fc0a710958b3599d5ad0c5971897d84c7e4552e2ca6" => :mojave
    sha256 "30d2d85dba7891d5eb5b43c69c5b6ac0ad0606d279c6a30e254f6ffd819356f8" => :high_sierra
  end

  uses_from_macos "unzip" => [:build, :test]
  uses_from_macos "zlib"

  resource "super_bat_puncher_demo" do
    url "http://morphcat.de/superbatpuncher/Super%20Bat%20Puncher%20Demo.zip"
    sha256 "d74cb3ba11a4ef5d0f8d224325958ca1203b0d8bb4a7a79867e412d987f0b846"
  end

  # Fixes an upstream issue which incorrectly attempts to use a Linux-only
  # function on macOS. Should be in the next release.
  # https://sourceforge.net/p/ucon64/svn/2763/
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/23a80b586dd35fdde1bf575c57a1b468631e644e/ucon64/sched_setscheduler.diff"
    sha256 "bb7bf52ec016092bf84b0a5eebb4295394288985993d4ab7a6b69a78c1c3ce77"
  end

  def install
    # ucon64's normal install process installs the discmage library in
    # the user's home folder. We want to store it inside the prefix, so
    # we have to change the default value of ~/.ucon64rc to point to it.
    # .ucon64rc is generated by the binary, so we adjust the default that
    # is set when no .ucon64rc exists.
    inreplace "src/ucon64_misc.c", "PROPERTY_MODE_DIR (\"ucon64\") \"#{shared_library("discmage")}\"",
                                   "\"#{opt_prefix}/libexec/#{shared_library("libdiscmage")}\""

    cd "src" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make"
      bin.install "ucon64"
      libexec.install "libdiscmage/#{shared_library("discmage")}" => shared_library("libdiscmage")
    end
  end

  def caveats
    <<~EOS
      You can copy/move your DAT file collection to $HOME/.ucon64/dat
      Be sure to check $HOME/.ucon64rc for configuration after running uCON64
      for the first time.
    EOS
  end

  test do
    resource("super_bat_puncher_demo").stage testpath

    assert_match "00000000  4e 45 53 1a  08 00 11 00  00 00 00 00  00 00 00 00",
                 shell_output("#{bin}/ucon64 \"#{testpath}/Super Bat Puncher Demo.nes\"")
  end
end
