class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.18.0-source.tar.xz"
  sha256 "592d4f6c0fba41bb954eb1a41616661b62b134d5b383e33bd45a081af5d4a59a"
  license "AGPL-3.0"
  head "https://git.ghostscript.com/mupdf.git"

  livecheck do
    url "https://mupdf.com/downloads/archive/?C=M&O=D"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e985551872925ed4b66ce995c551fda59152c1e7f9cf2bdbd205ab749e867e17" => :catalina
    sha256 "50f1628c7c396fdfd65eb5ce84541a5b9a695bc6fe003cc7abc732e212762bc3" => :mojave
    sha256 "2a7a4799ca7e75e948331ce00f5799ae8cb6ae2f23e1143955b9d03d8eccbcd9" => :high_sierra
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
