class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/v2.6.0.tar.gz"
  sha256 "45b41889065f8b840725928db092848b8a8b8d1bfae1b92e72f8868d1c76216c"
  license "Apache-2.0"
  revision 3
  head "https://github.com/ornladios/ADIOS2.git", branch: "master"

  bottle do
    sha256 "2e6889eacff86171837feafd9c53cf3c3f5ecb47323a4d5a50bba6439e743b6e" => :big_sur
    sha256 "b2e21f05ce51864584440bbee0df419a4adf1c842159af0a975415f2d31dbb9d" => :catalina
    sha256 "9b91ada3dc230fa55c94f8a13fbb7fa0483b5487d84c464d31b04fcc831148ba" => :mojave
    sha256 "3d12753838588f88e5e55de6095bc93af2731b34ff65c807414208cf443a3442" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "c-blosc"
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "python@3.9"
  depends_on "zeromq"
  uses_from_macos "bzip2"

  # macOS 10.13 configuration-time issue detecting float types
  # reference: https://github.com/ornladios/ADIOS2/pull/2305
  # can be removed after v2.6.0
  patch do
    url "https://github.com/ornladios/ADIOS2/commit/e92f052bc26816b30d3399343a005ea82b88afaf.patch?full_index=1"
    sha256 "6d0b84af71d6ccf4cf1cdad5e064cca837d505334316e7e78d18fa30a959666a"
  end

  def install
    # fix `include/adios2/common/ADIOSConfig.h` file audit failure
    inreplace "source/adios2/common/ADIOSConfig.h.in" do |s|
      s.gsub! ": @CMAKE_C_COMPILER@", ": /usr/bin/clang"
      s.gsub! ": @CMAKE_CXX_COMPILER@", ": /usr/bin/clang++"
    end

    args = std_cmake_args + %W[
      -DADIOS2_USE_Blosc=ON
      -DADIOS2_USE_BZip2=ON
      -DADIOS2_USE_DataSpaces=OFF
      -DADIOS2_USE_Fortran=ON
      -DADIOS2_USE_HDF5=OFF
      -DADIOS2_USE_IME=OFF
      -DADIOS2_USE_MGARD=OFF
      -DADIOS2_USE_MPI=ON
      -DADIOS2_USE_PNG=ON
      -DADIOS2_USE_Python=ON
      -DADIOS2_USE_SZ=OFF
      -DADIOS2_USE_ZeroMQ=ON
      -DADIOS2_USE_ZFP=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_BISON=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_CrayDRC=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_FLEX=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_LibFFI=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_NVSTREAM=TRUE
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
      -DADIOS2_BUILD_TESTING=OFF
      -DADIOS2_BUILD_EXAMPLES=OFF
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      rm_rf Dir[prefix/"bin/bp4dbg"] # https://github.com/ornladios/ADIOS2/pull/1846
    end

    (pkgshare/"test").install "examples/hello/bpWriter/helloBPWriter.cpp"
    (pkgshare/"test").install "examples/hello/bpWriter/helloBPWriter.py"
  end

  test do
    adios2_config_flags = `adios2-config --cxx`.chomp.split
    system "mpic++",
           (pkgshare/"test/helloBPWriter.cpp"),
           *adios2_config_flags
    system "./a.out"
    assert_predicate testpath/"myVector_cpp.bp", :exist?

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import adios2"
    system Formula["python@3.9"].opt_bin/"python3", (pkgshare/"test/helloBPWriter.py")
    assert_predicate testpath/"npArray.bp", :exist?
  end
end
