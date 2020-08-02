class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.18.1/cmake-3.18.1.tar.gz"
  sha256 "c0e3338bd37e67155b9d1e9526fec326b5c541f74857771b7ffed0c46ad62508"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "590ad7be94461516a5e9c2c4b52316bd77124671bc294835bb7caefc0056d0f6" => :catalina
    sha256 "9f0cf88ec2b2f5ba8f0e2dadaae8d287e650136a792589587d3472f481c90dda" => :mojave
    sha256 "38522cf8d87c44416649c349835e76583bdaa0c23bd68ce1ab4cc4df73f36658" => :high_sierra
  end

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
