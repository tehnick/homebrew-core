class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.6.0.tar.gz"
  sha256 "ab83b418f720effb4a626af7b851fa6421aa8cdb43f4f492ba81aa3ad148ad89"
  license "MIT"
  head "https://github.com/odygrd/quill.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63adcc4aa824061b010935f824208babaf0dc3537909024a6b8c6e73b00c68d9" => :big_sur
    sha256 "6c6a52facab9c272c622c090de6217068cf21e9ba24ab91876fda3a73385c618" => :catalina
    sha256 "9fe8025a5665dce0892a1fe1806d5572c49c463056f4b7eb36f37473d29a53fc" => :mojave
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "quill-build" do
      args = std_cmake_args
      args << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Quill.h"
      int main()
      {
        quill::start();
        quill::Handler* file_handler = quill::file_handler("#{testpath}/basic-log.txt", "w");
        quill::Logger* logger = quill::create_logger("logger_bar", file_handler);
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
