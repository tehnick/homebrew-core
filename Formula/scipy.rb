class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/93/63/4a566494594a13697c5d5d8a754d6e329d018ddf881520775e0229fa29ef/scipy-1.5.3.tar.gz"
  sha256 "ddae76784574cc4c172f3d5edd7308be16078dd3b977e8746860c76c195fa707"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "1327bbe2b07ef7056fb84f3e2763d2490ec49fdc2e4a190ca01edb0218a616cc" => :catalina
    sha256 "a3ebbef3da062ff7584f5b2a208f0b5d730795061f78fedaa3ce62a21ce89622" => :mojave
    sha256 "8958c94dd55cf780d3b048548810b971bb1f4777c58bb128fc11071913d9e6bf" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.9"

  cxxstdlib_check :skip

  # Fix compilation with Xcode 12
  # https://github.com/scipy/scipy/issues/12935
  # https://github.com/scipy/scipy/pull/12243
  patch do
    url "https://github.com/scipy/scipy/commit/b8e47064.patch?full_index=1"
    sha256 "2cb39e75f00d89564cdc769598bee2e772f6cb7bde5cc94560a2e588fb7a0027"
  end

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build", "--fcompiler=gnu95"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import scipy"
  end
end
