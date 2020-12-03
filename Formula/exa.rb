class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.9.0.tar.gz"
  sha256 "96e743ffac0512a278de9ca3277183536ee8b691a46ff200ec27e28108fef783"
  license "MIT"
  revision 1

  livecheck do
    url "https://github.com/ogham/exa/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3ee8e461f50fa870cd035a44ba9973e26192953e235adef9d2936f2bdab0b1d3" => :big_sur
    sha256 "33332800316bd21da72087c8d21d2948e7b0bf678fc9d3c562c9e84c139b6de3" => :catalina
    sha256 "507c870baae72b7961d695abbbee5029b86aee3e88037fafd08f4b55d78257b2" => :mojave
  end

  head do
    url "https://github.com/ogham/exa.git"
    depends_on "pandoc" => :build
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libgit2"
  end

  def install
    system "cargo", "install", *std_cargo_args

    # Remove in 0.9+
    if build.head?
      bash_completion.install "completions/completions.bash" => "exa"
      zsh_completion.install  "completions/completions.zsh"  => "_exa"
      fish_completion.install "completions/completions.fish" => "exa.fish"

      args = %w[
        --standalone
        --to=man
      ]

      system "pandoc", *args, "man/exa.1.md", "-o", "exa.1"
      system "pandoc", *args, "man/exa_colors.5.md", "-o", "exa_colors.5"

      man1.install "exa.1"
      man5.install "exa_colors.5"
    else
      bash_completion.install "contrib/completions.bash" => "exa"
      zsh_completion.install  "contrib/completions.zsh"  => "_exa"
      fish_completion.install "contrib/completions.fish" => "exa.fish"
      man1.install "contrib/man/exa.1"
    end
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
