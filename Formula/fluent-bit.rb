class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.2.tar.gz"
  sha256 "d94e2eb98f977fdbea169cf4906c10450a13ea52c74d950bb3d170b3b9ff85d6"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "a0db82c901511a03b48ae2ceb5711f626965bb3a296550658e722e257d296f60" => :catalina
    sha256 "d586847eca6eebc9241f5310b0df3a4442086af3afbde5071621673525b36480" => :mojave
    sha256 "52f91f4fdbe28417726518ba4470f68552dc92a2a4b55dd665d840f12b53e9f7" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
