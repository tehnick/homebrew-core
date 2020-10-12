class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.60.tar.gz"
  sha256 "74046306e9fb299924dfa0a149554652f0b7a279df38a7da046e7d2e84513791"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "9f3a305d79d60c0ca4350b99303d62ee03bbad4ae6879caaf7aec64da715e99f" => :catalina
    sha256 "091ba071b436ed6aa1b3f3d3dde78133930fd9ca105d2672508d27c2b9dcc34b" => :mojave
    sha256 "ed49c6e7a6c7ecb9052fb3e5cc1c770dd5d7a6165b2b299a24c0c8860cc9ecc1" => :high_sierra
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
