class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.106.tgz"
  sha256 "e31f43fcd984f17c0f10fb4e26bed4203919a5c8c9f1beafc9aafcb5f85d72b7"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  livecheck do
    url "https://github.com/verilator/verilator.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "f7def3eedd4e4ceb417b02054986524d0c69818c8837fc5a2ed479001804f93e" => :big_sur
    sha256 "8c9d1253dd911dca93ddc8e2da53aed9b634c0cafa26609b13a123254d7679c0" => :catalina
    sha256 "f45ae45c72884a8da166bbc4fb0eea4f4e602aaa8c89c2c2594cc851dd46338b" => :mojave
  end

  head do
    url "https://git.veripool.org/git/verilator", using: :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.v").write <<~EOS
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "Vtest.h"
      #include "verilated.h"
      int main(int argc, char **argv, char **env) {
          Verilated::commandArgs(argc, argv);
          Vtest* top = new Vtest;
          while (!Verilated::gotFinish()) { top->eval(); }
          delete top;
          exit(0);
      }
    EOS
    system "/usr/bin/perl", bin/"verilator", "-Wall", "--cc", "test.v", "--exe", "test.cpp"
    cd "obj_dir" do
      system "make", "-j", "-f", "Vtest.mk", "Vtest"
      expected = <<~EOS
        Hello World
        - test.v:2: Verilog $finish
      EOS
      assert_equal expected, shell_output("./Vtest")
    end
  end
end
