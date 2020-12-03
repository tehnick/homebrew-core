class RustupInit < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.23.1.tar.gz"
  sha256 "0203231bfe405ee1c7d5e7e1c013b9b8a2dc87fbd8474e77f500331d8c26365f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ca4f2a444efa1b2304799b1f2ccc4d835f30b422e1281381d0ef417eecd57ce" => :big_sur
    sha256 "bdde9b0a17227a4dbc37c52b66a921f95ac9c760c133c4b401f0abc42c05b1aa" => :catalina
    sha256 "f8501b29816fb534524bd36dc46a679456361a7a0b35e6ebc6f5b0dd75083c00" => :mojave
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--features", "no-self-update", *std_cargo_args
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".multirust"

    system bin/"rustup-init", "-y"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system testpath/".cargo/bin/rustc", "hello.rs"
    assert_equal "Hello World!", shell_output("./hello").chomp
  end
end
