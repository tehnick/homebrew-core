class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.40.0.tar.gz"
  sha256 "7270081d6a289b1f8eee57b46d0e5bced1f912bbd7630281f7a72a741c98ba3b"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url "https://github.com/IntelRealSense/librealsense/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "d995adb24a512a8929a62afd27b707128e0b3e1cde800657f492f6acdef953ae" => :big_sur
    sha256 "131bf7725b0c0b9bd5d453bf29239837b5205dadef3c490ddfd29eae7d4cb9d0" => :catalina
    sha256 "f028aff08fe944960c3801a7e7ac342309fa1f643f2244a7f8b3503208692083" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DENABLE_CCACHE=OFF"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
