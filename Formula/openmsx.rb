class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_0_15_0/openmsx-0.15.0.tar.gz"
  sha256 "93f209d8fed2e04e62526469bb6bb431b82ea4d07ecdc45dab2b8cc4ca21d62a"
  license "GPL-2.0"
  revision 1
  head "https://github.com/openMSX/openMSX.git"

  bottle do
    cellar :any
    sha256 "10c3e39c22efbd11e11b352f8fabfcea03633088cb16fe24611ed631325ed05c" => :catalina
    sha256 "ed24d06d8f8913236fa619f0d92396e2a2a8d2f40afb5e56c609ecdf332b4ca4" => :mojave
    sha256 "86fff1a90fff96cb0398184ef7ebdeb804edda4c9d34ee5e7278159df64b10e3" => :high_sierra
  end

  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_ttf"

  def install
    # Fixes a clang crash; this is an LLVM/Apple bug, not an openmsx bug
    # https://github.com/Homebrew/homebrew-core/pull/9753
    # Filed with Apple: rdar://30475877
    ENV.O0

    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    inreplace "build/libraries.py" do |s|
      s.gsub! /\((distroRoot), \)/, "(\\1, '/usr', '#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework')"
      s.gsub! "lib/tcl", "."
    end

    system "./configure"
    system "make"
    prefix.install Dir["derived/**/openMSX.app"]
    bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
