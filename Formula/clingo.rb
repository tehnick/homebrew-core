class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.4.0.tar.gz"
  sha256 "e2de331ee0a6d254193aab5995338a621372517adcf91568092be8ac511c18f3"
  license "MIT"
  revision 3

  livecheck do
    url "https://github.com/potassco/clingo/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "9a02b6ced933810e4cff55143989e37ef08d22bcf6a945a9682d3d73a0accedb" => :big_sur
    sha256 "5c6dd1f45a2cfe48e4616c6e4bcc45a8b9b5ab050016ad8db6c38bd810129985" => :catalina
    sha256 "55a5d161667e66004aa6d56f92ab00ccefb6863094fd2ba3c113b6d20d741968" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "lua"
  depends_on "python@3.9"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  # Patch adds Python 3.8 compatibility
  patch do
    url "https://github.com/potassco/clingo/commit/13a896b6a762e48c2396e3dc9f2e794020f4e6e8.patch?full_index=1"
    sha256 "f2840bc4ab5159c253c5390c845f0d003f5fef813f49ddca27dbd5245f535e79"
  end

  def install
    system "cmake", ".", "-DCLINGO_BUILD_WITH_PYTHON=ON",
                         "-DCLINGO_BUILD_PY_SHARED=ON",
                         "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                         "-DCLINGO_BUILD_WITH_LUA=ON",
                         "-DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                         "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clingo --version")
  end
end
