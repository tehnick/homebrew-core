class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/xcb-proto-1.13.tar.bz2"
  sha256 "7b98721e669be80284e9bbfeab02d2d0d54cd11172b72271e47a2fe875e2bde1"
  license "MIT"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f1784c79ed426c069f6a63bc93cfa81bdbf2927c88f44f46bdbe7721095a545a" => :catalina
    sha256 "632746e279433e8ec37e692bd9f90475d7a8cb16dbc743641677937e74974027" => :mojave
    sha256 "428b789f3406ebfc2c4b1857cb8ca900853e2cc75d314588002484a2a8648d87" => :high_sierra
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      PYTHON=python3
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "#{share}/xcb", shell_output("pkg-config --variable=xcbincludedir xcb-proto").chomp
  end
end
